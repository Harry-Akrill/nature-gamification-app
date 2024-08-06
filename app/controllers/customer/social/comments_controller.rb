# frozen_string_literal: true

module Customer
  module Social
    class CommentsController < ApplicationController
      before_action :authorize_customer_controllers, :get_user
      before_action :set_post
      before_action :set_comment, only: %i[update destroy]
      before_action :authorize_comment, only: %i[update destroy]

      def index
        @comments = @post.comments
        render json: @comments
      end

      def create
        @comment = @post.comments.build(comment_params)
        @comment.user = @user

        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy
        head :no_content
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end

      def authorize_comment
        return if @comment.user_id == @user.id

        render json: {error: "Not authorized"}, status: :unauthorized
      end

      def get_user
        @user = current_user

        render_internal_server_error if @user.nil?
      end
    end
  end
end
