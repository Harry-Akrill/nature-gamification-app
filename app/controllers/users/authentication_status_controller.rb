# frozen_string_literal: true

module Users
  class AuthenticationStatusController < ApplicationController
    def index
      user_type = authenticated?

      if authenticated?
        render json: {userType: user_type}
      else
        render json: {userType: "Not Authenticated"}, status: :unauthorized
      end
    end
  end
end
