# frozen_string_literal: true

module Stats
  class AdminPageController < ApplicationController
    before_action :authorize_admin_controllers

    # rubocop:disable Metrics/AbcSize
    def register_new_page_visit
      return render_bad_request if geolocation_from_ip(request.remote_ip).nil?

      page_visit = AdminPageVisit.new(session_id: session.id, ip_address: request.remote_ip)
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
      return render_bad_request if geolocation_from_ip(ip).nil?

      page_visit = AdminPageVisit.new(session_id: session.id, ip_address: ip)
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
      return render_bad_request unless AdminPageVisit.exists?(id: visit_id)

      page_visit = AdminPageVisit.find(visit_id)
      page_visit.time_spent_seconds = time_spent_seconds
      return render_internal_server_error unless page_visit.valid?

      page_visit.save
      render json: {message: "Page visit updated successfully"}
    end
    # rubocop:enable Metrics/AbcSize
  end
end
