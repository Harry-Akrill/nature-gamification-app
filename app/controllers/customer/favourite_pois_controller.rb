# frozen_string_literal: true

module Customer
  class FavouritePoisController < ApplicationController
    before_action :authorize_customer_controllers, :get_user

    def all
      pois_formatted = @user.favourite_pois.map do |poi|
        {
          lngLat:      {lng: poi.longitude, lat: poi.latitude},
          name:        poi.name,
          id:          poi.id,
          isFavourite: true,
          description: poi.description,
          features:    poi.features,
          likes:       poi.likes,
          pictures:    poi.poi_pictures.map {|poi_picture| url_for(poi_picture.picture) }, # Include picture URLs,
          checkedIn:   poi.check_ins.exists?(user: @user),
          comments:    [] # Add later...
        }
      end

      render json: pois_formatted
    end

    def single_poi_favourite_status
      poi_id = params[:poi_id]

      return render_bad_request if poi_id.blank?

      poi = Poi.find(poi_id)

      return render_bad_request if poi.nil?

      render json: poi.favourites.exists?(user: @user)
    end

    def add
      poi_id = params[:poi_id]

      return render_bad_request if poi_id.blank?

      poi = Poi.find(poi_id)

      return render_bad_request if poi.nil?

      favourite = @user.favourites.create(poi:)

      if favourite.persisted?
        render json: {message: "OK"}
      else
        render_internal_server_error
      end
    end

    def remove
      poi_id = params[:poi_id]

      return render_bad_request if poi_id.blank?

      poi = Poi.find(poi_id)

      return render_bad_request if poi.nil?

      favourite = @user.favourites.find_by(poi:)

      if favourite
        favourite.destroy
        render json: {message: "OK"}
      else
        render_internal_server_error
      end
    end

    private

    def get_user
      @user = current_user

      render_internal_server_error if @user.nil?
    end
  end
end
