# frozen_string_literal: true

module ApplicationHelper
  def authenticated?
    user = current_user

    return false unless user

    user.user_type
  end

  def current_user
    return false if cookies[:access_token].blank?

    jwt_payload = JWT.decode(cookies[:access_token], Rails.application.secrets.devise_jwt_secret_key!).first
    current_user = User.find(jwt_payload["sub"])

    return false unless current_user

    current_user
  end

  def customer?
    user = current_user

    return false if !user || user.user_type != "customer"

    true
  end

  def admin?
    user = current_user

    return false if !user || user.user_type != "admin"

    true
  end

  def reporter?
    user = current_user

    return false if !user || user.user_type != "reporter"

    true
  end

  def authorize_customer_controllers
    render json: {message: "Not Authorized"}, status: :unauthorized unless customer?
  end

  def authorize_admin_controllers
    render json: {message: "Not Authorized"}, status: :unauthorized unless admin?
  end

  def authorize_reporter_controllers
    render json: {message: "Not Authorized"}, status: :unauthorized unless reporter?
  end

  def render_bad_request
    render json: {message: "Bad request"}, status: :bad_request
  end

  def render_internal_server_error
    render json: {message: "Internal server error"}, status: :internal_server_error
  end

  def geolocation_from_ip(ip)
    results = Geocoder.search(ip)
    return nil if results.first.nil?

    coords = results.first.coordinates
    return {lat: coords[0], lon: coords[1]} if coords.present?

    nil
  end

  def country_from_ip(ip)
    results = Geocoder.search(ip)
    return nil if results.first.nil?

    country = results.first.country
    return country if country.present?

    nil
  end
end
