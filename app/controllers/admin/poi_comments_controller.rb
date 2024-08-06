# frozen_string_literal: true

module Admin
  class PoiCommentsController < ApplicationController
    before_action :authorize_admin_controllers

    def all_comments
      Rails.logger.info "Fetching all reported comments..."
      reported_comments = PoiComment.where(reported: true).order(created_at: :desc)
      Rails.logger.info "Reported comments fetched: #{reported_comments.inspect}"

      reported_comments_with_user_info = []

      reported_comments.each do |comment|
        user = User.find_by(id: comment.user_id)
        poi = Poi.find_by(id: comment.poi_id)

        next unless user && poi

        user_nickname = user.nickname
        poi_name = poi.name

        reported_comments_with_user_info << {
          id:            comment.id,
          user_nickname:,
          poi_name:,
          text:          comment.text,
          rating:        comment.rating
        }
      end
      Rails.logger.info "Reported comments fetched with user nicknames: #{reported_comments_with_user_info}"
      render json: reported_comments_with_user_info
    end

    def delete_comment
      comment = PoiComment.find_by(id: params[:id])
      if comment
        if comment.destroy
          render json: {message: "Comment deleted successfully"}, status: :ok
        else
          render json: {error: "Failed to delete comment"}, status: :unprocessable_entity
        end
      else
        render json: {error: "Comment not found"}, status: :not_found
      end
    end

    def toggle_report_status
      @comment = PoiComment.find(params[:id])
      @comment.update(reported: !@comment.reported)
    end

    private

    def comment_params
      params.require(:poi_comment).permit(:id, :user_id, :poi_id, :text, :rating)
    end
  end
end
