# frozen_string_literal: true

module Customer
  class PoiCommentsController < ApplicationController
    before_action :authorize_customer_controllers, :get_user

    def all
      poi_id = params[:poiId]
      Rails.logger.debug { "Received poi_id: #{poi_id}" }

      comments = PoiComment.where(poi_id:).map do |comment|
        {
          id:       comment.id,
          userId:   comment.user_id,
          nickname: comment.user.nickname,
          poiId:    comment.poi_id,
          text:     comment.text,
          rating:   comment.rating
        }
      end
      Rails.logger.debug { "Selected comments: #{comments}" }

      render json: comments
    end

    def create
      return render json: {error: "Unauthorized"}, status: :unauthorized unless @user

      Rails.logger.debug { "Incoming parameters: #{params}" }

      unless Poi.exists?(id: comment_params[:poi_id])
        return render json:   {error: "Invalid POI ID"},
                      status: :unprocessable_entity
      end

      Poi.find(comment_params[:poi_id])

      comment = @user.poi_comments.build(comment_params)
      Rails.logger.debug { "New comment: #{comment.inspect}" }

      if comment.user_id != @user.id
        return render json: {error: "User ID does not match the current user"}, status: :unprocessable_entity
      end

      if comment.save
        render json: comment, status: :created
      else
        render json: {error: comment.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def report
      @comment = PoiComment.find(params[:id])
      if @comment.update(reported: params[:reported])
        Rails.logger.debug { "Reported comment: #{@comment.inspect}" }

        render json: {message: "Comment reported successfully."}, status: :ok
      else
        render json: {error: "Failed to report comment."}, status: :unprocessable_entity
      end
    end

    private

    def get_user
      @user = current_user
      render_internal_server_error if @user.nil?
    end

    def comment_params
      params.require(:poi_comment).permit(:id, :user_id, :poi_id, :text, :rating, :reported)
    end
  end
end
