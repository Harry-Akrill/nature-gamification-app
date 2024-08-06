# frozen_string_literal: true

class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # Disabling caching will prevent sensitive information being stored in the
  # browser cache. If your app does not deal with sensitive information then it
  # may be worth enabling caching for performance.
  before_action :update_headers_to_disable_caching, :initialize_session
  include ActionController::Cookies
  include ApplicationHelper

  private

  def update_headers_to_disable_caching
    response.headers["Cache-Control"] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "-1"
  end

  def initialize_session
    session[:force_session_initialization] ||= true
  end
end
