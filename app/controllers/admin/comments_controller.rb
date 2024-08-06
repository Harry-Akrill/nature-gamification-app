module Admin
  class CommentsController < ApplicationController
    before_action :authorize_admin_controllers

      def all_comments
        Rails.logger.info "Fetching all reported comments..."
        reported_comments = PoiComment.where(reported: true).order(created_at: :desc)
        Rails.logger.info "Reported comments fetched: #{reported_comments.inspect}"
        
        # Create an array to store the reported comments with user information
        reported_comments_with_user_info = []
        
        # Loop through each reported comment to retrieve user information
        reported_comments.each do |comment|
          user = User.find_by(id: comment.user_id)
          poi = Poi.find_by(id: comment.poi_id)
      
          # Proceed only if both user and POI exist
          if user && poi
            user_nickname = user.nickname
            poi_name = poi.name
      
            # Push the reported comment with user information into the array
            reported_comments_with_user_info << {
              id: comment.id,
              user_nickname: user_nickname,
              poi_name: poi_name,
              text: comment.text,
              rating: comment.rating
            }
          end
        end
        Rails.logger.info "Reported comments fetched with user nicknames: #{reported_comments_with_user_info}"
        render json: reported_comments_with_user_info
      end
     

      def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def delete_comment
        comment = PoiComment.find_by(id: params[:id])
        if comment
          if comment.destroy

            render json: { message: 'Comment deleted successfully' }, status: :ok
          else
            render json: { error: 'Failed to delete comment' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Comment not found' }, status: :not_found
        end
      end

      def create_email
        Rails.logger.info "Check: #{PoiComment.all.inspect}"
        comment = PoiComment.find(params[:id])
      
        Rails.logger.info "Check: #{comment.inspect}"
      
        user_email = User.find(comment.user_id).email
        Rails.logger.info "Email to: #{user_email}"
      
        ReportedCommentMailer.reported_comments_noti(user_email).deliver_now
      
        render json: { message: 'Email notification sent successfully' }, status: :ok
      end
      

      def toggle_report_status
        @comment = PoiComment.find(params[:id])
      
        # Log the id parameter
        Rails.logger.info("ID received in toggle_report_status: #{params[:id]}")
      
        @comment.update(reported: !@comment.reported)
        render json: { message: 'Status is changed to ok' }
      end

      private
      # Only allow a list of trusted parameters through.
      def comment_params
        params.require(:comment).permit(:id, :user_id, :poi_id, :text, :rating)
      end
  end
end
