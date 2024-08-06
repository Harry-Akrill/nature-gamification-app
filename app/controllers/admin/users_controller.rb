# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authorize_admin_controllers

    def all_users
      render json: {users: User.select(:id, :email, :user_type, :deactivated)}
    end

    def update_user
      @user = User.find(params[:id])
      @user.email = params[:email] if update_email?
      @user.user_type = params[:user_type] if update_user_type?
      return render_bad_request unless @user.valid?

      @user.save
      render json: {message: "Updated user successfully"}
    end

    def delete_user
      user = User.find(params[:id])
      return render_bad_request if user.nil?

      user.destroy
      render json: {message: "Deleted user successfully"}
    end

    def deactivate_user
      user = User.find(params[:id])
      return render_bad_request if user.nil?

      user.deactivated = true
      user.save
      render json: {message: "Deactivated user successfully"}
    end

    def activate_user
      user = User.find(params[:id])
      return render_bad_request if user.nil?

      user.deactivated = false
      user.save
      render json: {message: "Activated user successfully"}
    end

    # EMAIL_REGEX = /^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+$/
    # EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/

    private

    def valid_user_type?(user_type)
      %w[customer admin reporter].include?(user_type)
    end

    def valid_email?(email_)
      email_.match(EMAIL_REGEX)
    end

    def update_email?
      !params[:email].nil? && @user.email != params[:email] && valid_email?(params[:email])
    end

    def update_user_type?
      !params[:user_type].nil? && @user.user_type != params[:user_type] && valid_user_type?(params[:user_type])
    end
  end
end
