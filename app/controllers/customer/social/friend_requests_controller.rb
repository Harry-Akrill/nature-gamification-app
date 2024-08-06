# frozen_string_literal: true

module Customer
  module Social
    class FriendRequestsController < ApplicationController
      before_action :authorize_customer_controllers, :get_user
      # before_action :authenticate_user!
      before_action :set_friend_request, except: %i[index create]

      def index
        @incoming = FriendRequest.where(friend: @user).includes(:user)
        @outgoing = @user.friend_requests.includes(:friend)

        render json: {incoming: @incoming.as_json(include: :user),
                      outgoing: @outgoing.as_json(include: {friend: {only: :nickname}})}
      end

      def show
        @friend_request = FriendRequest.find(params[:id])
      end

      def create
        friend_id = params[:friend_id].to_i
        unless friend_id.to_s == params[:friend_id].to_s && User.exists?(friend_id)
          render json: {error: "Invalid friend_id param"}, status: :unprocessable_entity
          return
        end

        friend = User.find(params[:friend_id])
        @friend_request = @user.friend_requests.new(friend:)

        if @friend_request.save
          FriendRequestMailer.friend_request(@friend_request).deliver_now
          render :show, status: :created, location: customer_social_friend_request_url(@friend_request)
        else
          render json: @friend_request.errors, status: :unprocessable_entity
        end
      end

      def update
        @friend_request.accept
        head :no_content
      end

      def destroy
        @friend_request.destroy
        head :no_content
      end

      private

      def set_friend_request
        @friend_request = FriendRequest.find(params[:id])
      end

      def get_user
        @user = current_user

        render_internal_server_error if @user.nil?
      end
    end
  end
end
