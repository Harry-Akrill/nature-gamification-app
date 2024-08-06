# frozen_string_literal: true

module Customer
  class PointsBadgesController < ApplicationController
    before_action :authorize_customer_controllers, :get_user

    def all
      total_points = @user.total_points
      total_check_in_counts = @user.total_check_in_counts
      total_poi_photo_counts = @user.total_poi_photo_counts
      total_poi_review_counts = @user.total_poi_review_counts
      badge_statuses_for_total_points = @user.badge_statuses_for_total_points
      badge_statuses_for_total_check_in_counts = @user.badge_statuses_for_total_check_in_counts
      badge_statuses_for_total_poi_photo_counts = @user.badge_statuses_for_total_poi_photo_counts
      badge_statuses_for_total_poi_review_counts = @user.badge_statuses_for_total_poi_review_counts

      render json: {
        totalPoints:                          total_points,
        totalCheckInCounts:                   total_check_in_counts,
        totalPoiPhotoCounts:                  total_poi_photo_counts,
        totalPoiReviewCounts:                 total_poi_review_counts,
        badgeStatusesForTotalPoints:          badge_statuses_for_total_points,
        badgeStatusesForTotalCheckInCounts:   badge_statuses_for_total_check_in_counts,
        badgeStatusesForTotalPoiPhotoCounts:  badge_statuses_for_total_poi_photo_counts,
        badgeStatusesForTotalPoiReviewCounts: badge_statuses_for_total_poi_review_counts
      }
    end

    def avatar_dropdown_current_total_points
      total_points = @user.total_points

      badge_statuses = @user.badge_statuses_for_total_points
      currently_in_progress = badge_statuses.find {|badge_status| badge_status[:status] == "IN PROGRESS" }
      currently_in_progress = Constants::BADGES[-1] if currently_in_progress.nil?

      render json: {totalPoints: total_points, badge: currently_in_progress[:badge],
threshold: currently_in_progress[:threshold], previousThreshold: currently_in_progress[:previous_threshold]}
    end

    def all_in_progress
      total_points_in_progress = find_badge_status_in_progress(@user.badge_statuses_for_total_points)
      total_check_ins_in_progress = find_badge_status_in_progress(@user.badge_statuses_for_total_check_in_counts)
      total_poi_photos_in_progress = find_badge_status_in_progress(@user.badge_statuses_for_total_poi_photo_counts)
      total_poi_reviews_in_progress = find_badge_status_in_progress(@user.badge_statuses_for_total_poi_review_counts)

      render json: {total_points_in_progress:, total_check_ins_in_progress:,
      total_poi_photos_in_progress:, total_poi_reviews_in_progress:}
    end

    private

    def get_user
      @user = current_user

      render_internal_server_error if @user.nil?
    end

    def find_badge_status_in_progress(badge_statuses)
      badge_statuses.find {|badge_status|
        badge_status[:status] == "IN PROGRESS"
      }
    end
  end
end
