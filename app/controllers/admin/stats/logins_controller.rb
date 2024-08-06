# frozen_string_literal: true

module Admin
  module Stats
    class LoginsController < ApplicationController
      before_action :authorize_admin_controllers

      def all
        app_visits = AppVisit.all
        app_visits_json = app_visits.map do |visit|
          visit_json = visit.as_json.slice("id", "session_id", "email", "country", "ip_address",
                                           "time_spent_seconds", "created_at")
          visit_json.merge!(
            "latitude"  => visit.latitude.to_f,
            "longitude" => visit.longitude.to_f
          )
        end
        render json: app_visits_json
      end
    end
  end
end
