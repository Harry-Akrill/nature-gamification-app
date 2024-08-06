# frozen_string_literal: true

module Customer
  module Social
    class FriendsController < ApplicationController
      before_action :authorize_customer_controllers, :get_user
      # before_action :authenticate_user!
      before_action :set_friend, only: :destroy

      def index
        @friends = @user.friends.where.not(id: @user.blocked_users)
        render json: @friends
      end

      def destroy
        @user.remove_friend(@friend, @user)
        head :no_content
      end

      private

      def set_friend
        @friend = @user.friends.find(params[:id])
      end

      def get_user
        @user = current_user

        render_internal_server_error if @user.nil?
      end
    end
  end
end
