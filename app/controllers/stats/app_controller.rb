# frozen_string_literal: true

module Stats
  class AppController < ApplicationController
    before_action :authorize_customer_controllers

    # rubocop:disable Metrics/AbcSize
    def register_new_page_visit
      coords = geolocation_from_ip(request.remote_ip)
      return render_bad_request if coords.nil?

      country = country_from_ip(request.remote_ip)
      return render_bad_request if country.nil?

      user = current_user
      page_visit = AppVisit.new(session_id: session.id, ip_address: request.remote_ip, latitude: coords[:lat],
                                longitude: coords[:lon], country:, email: user.email)
      return render_internal_server_error unless page_visit.valid?

      page_visit.save
      session[:visit_id] = page_visit.id
      render json: {message: "Registered new visit successfully"}
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    def register_new_page_visit_with_ip_param
      ip = params[:ip]
      return render_bad_request if ip.nil?

      coords = geolocation_from_ip(ip)
      return render_bad_request if coords.nil?

      country = country_from_ip(ip)
      return render_bad_request if country.nil?

      user = current_user
      page_visit = AppVisit.new(session_id: session.id, ip_address: ip, latitude: coords[:lat],
                                longitude: coords[:lon], country:, email: user.email)
      return render_internal_server_error unless page_visit.valid?

      page_visit.save
      session[:visit_id] = page_visit.id
      render json: {message: "Registered new visit successfully"}
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    def update_page_visit
      time_spent_seconds = params[:time_spent_seconds]
      return render_bad_request if time_spent_seconds.nil?
      return render_bad_request unless time_spent_seconds.to_i.is_a?(Integer) && time_spent_seconds.to_i >= 0

      visit_id = session[:visit_id]
      return render_bad_request if visit_id.nil?
      return render_bad_request unless AppVisit.exists?(id: visit_id)

      page_visit = AppVisit.find(visit_id)
      page_visit.time_spent_seconds = time_spent_seconds
      return render_internal_server_error unless page_visit.valid?

      page_visit.save
      render json: {message: "Page visit updated successfully"}
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    def register_new_poi_click
      poi_id = params[:poi_id].to_i
      return render_bad_request if poi_id.nil? || !Poi.exists?(id: poi_id)

      visit_id = session[:visit_id]
      return render_bad_request if visit_id.nil? || !AppVisit.exists?(id: visit_id)

      page_visit = AppVisit.find(visit_id)
      page_visit.viewed_pois.push(poi_id)
      if page_visit.save
        render json: {message: "POI click registered successfully"}
      else
        render_internal_server_error
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
