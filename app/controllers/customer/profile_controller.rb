# frozen_string_literal: true

module Customer
  class ProfileController < ApplicationController
    before_action :authorize_customer_controllers

    def show
      @user = current_user

      return render json: @user.slice(:nickname, :email, :description) unless @user.profile_picture.attached?

      render json: @user.slice(:nickname, :email,
                               :description).merge({profile_picture: url_for(@user.profile_picture)})
    end

    def update_user_profile
      @user = current_user

      if @user.update(user_params)
        show
      else
        render json: @user.errors, status: :internal_server_error
      end
    end

    def update_profile_picture
      @user = current_user
      @user.profile_picture.attach(params[:profile_picture])

      if @user.save
        show
      else
        render json: @user.errors, status: :internal_server_error
      end
    end

    private

    def user_params
      params.require(:user).permit(:nickname, :description)
    end
  end
end
