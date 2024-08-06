# frozen_string_literal: true

module Customer
  class CheckInController < ApplicationController
    before_action :authorize_customer_controllers, :get_user
    before_action :process_params, only: %i[check_in_candidates register_check_in]

    MAXIMUM_DISTANCE_FOR_CHECK_IN_THRESHOLD_METERS = 500
    def check_in_candidates
      candidates = check_in_candidates_haversine(@latitude, @longitude, @accuracy_meters)
      render json: candidates
    end

    def register_check_in
      poi_id = params[:poi_id]

      return render_bad_request if poi_id.blank?

      poi = Poi.find(poi_id)
      return render_bad_request if poi.nil?

      distance = haversine_distance(@latitude, @longitude, poi.latitude, poi.latitude)

      return render_bad_request if distance - @accuracy_meters > MAXIMUM_DISTANCE_FOR_CHECK_IN_THRESHOLD_METERS

      check_in = @user.check_ins.create(poi:)

      if check_in.persisted?
        render json: {message: "OK"}
      else
        render_internal_server_error
      end
    end

    def all
      pois_formatted = @user.checked_in_pois.map do |poi|
        {
          lngLat:      {lng: poi.longitude, lat: poi.latitude},
          name:        poi.name,
          id:          poi.id,
          isFavourite: poi.favourites.exists?(user: @user),
          description: poi.description,
          features:    poi.features,
          likes:       poi.likes,
          pictures:    poi.poi_pictures.map {|poi_picture|
                         url_for(poi_picture.picture)
                       }, # Include picture URLs,
          checkedIn:   true,
          comments:    [] # Add later...
        }
      end

      render json: pois_formatted
    end

    def single_poi_check_in_status
      poi_id = params[:poi_id]

      return render_bad_request if poi_id.blank?

      poi = Poi.find(poi_id)

      return render_bad_request if poi.nil?

      render json: poi.check_ins.exists?(user: @user)
    end

    private

    def process_params
      latitude = params[:latitude]
      longitude = params[:longitude]
      accuracy_meters = params[:accuracy_meters]

      if latitude.present? && valid_decimal?(latitude) &&
         longitude.present? && valid_decimal?(longitude) &&
         accuracy_meters.present? && valid_decimal?(accuracy_meters)

        @latitude = latitude.to_d
        @longitude = longitude.to_d
        @accuracy_meters = accuracy_meters.to_d
      else
        render_bad_request
      end
    end

    def valid_decimal?(str)
      true if Float(str)
    rescue StandardError
      false
    end

    def get_user
      @user = current_user

      render_internal_server_error if @user.nil?
    end

    def haversine_distance(lat1, lng1, lat2, lng2)
      earth_radius_km = 6371.0
      earth_radius_m = earth_radius_km * 1000

      lat1_rad = lat1 * Math::PI / 180
      lng1_rad = lng1 * Math::PI / 180
      lat2_rad = lat2 * Math::PI / 180
      lng2_rad = lng2 * Math::PI / 180

      delta_lat = lat2_rad - lat1_rad
      delta_lng = lng2_rad - lng1_rad

      a = (Math.sin(delta_lat / 2)**2) + (Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(delta_lng / 2)**2))
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      earth_radius_m * c
    end

    def check_in_candidates_haversine(user_latitude, user_longitude, user_accuracy_meters)
      earth_radius_km = 6371.0
      earth_radius_m = earth_radius_km * 1000

      pois = Poi.where(%{
          (#{earth_radius_m} * acos(cos(radians(:latitude)) * cos(radians(latitude)) *
          cos(radians(longitude) - radians(:longitude)) + sin(radians(:latitude)) *
          sin(radians(latitude)))) <= :maximum_distance
        }, latitude: user_latitude, longitude: user_longitude,
      maximum_distance: MAXIMUM_DISTANCE_FOR_CHECK_IN_THRESHOLD_METERS + user_accuracy_meters)

      pois.map do |poi|
        next if poi.check_ins.exists?(user: @user)

        {
          lngLat:      {lng: poi.longitude, lat: poi.latitude},
          name:        poi.name,
          id:          poi.id,
          isFavourite: poi.favourites.exists?(user: @user),
          description: poi.description,
          features:    poi.features,
          likes:       poi.likes,
          pictures:    poi.poi_pictures.map {|poi_picture| url_for(poi_picture.picture) }, # Include picture URLs,
          checkedIn:   false,
          comments:    [] # Add later...
        }
      end.compact
    end
  end
end
