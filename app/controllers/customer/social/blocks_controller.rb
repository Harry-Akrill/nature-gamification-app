# frozen_string_literal: true

module Customer
  module Social
    class BlocksController < ApplicationController
      before_action :authorize_customer_controllers, :get_user

      def index
        blocked_users = @user.blocks.map do |block|
          User.find(block.blocked_user_id)
        end
        render json: blocked_users
      end

      def block
        @user.blocks.create(blocked_user_id: params[:id])
        head :no_content
      end

      def unblock
        block = @user.blocks.find_by(blocked_user_id: params[:id])
        if block
          block.destroy
          render json: {message: "User unblocked successfully"}, status: :ok
        else
          render json: {error: "Block not found"}, status: :not_found
        end
      end

      private

      def get_user
        @user = current_user

        render_internal_server_error if @user.nil?
      end
    end
  end
end
