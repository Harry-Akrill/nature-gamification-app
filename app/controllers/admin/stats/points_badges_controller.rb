# frozen_string_literal: true

module Admin
  module Stats
    class PointsBadgesController < ApplicationController
      before_action :authorize_admin_controllers

      def all
        initial_badge_counts = Constants::BADGES.index_with {|_badge| 0 }

        total_user_badges_for_total_points_achieved = initial_badge_counts.dup
        total_user_badges_for_total_check_ins_achieved = initial_badge_counts.dup
        total_user_badges_for_total_poi_photos_achieved = initial_badge_counts.dup
        total_user_badges_for_total_poi_reviews_achieved = initial_badge_counts.dup

        User.find_each do |user|
          achieved_badges_for_total_points = find_all_achieved_badge_statuses(user.badge_statuses_for_total_points).map {|status|
            status[:badge].to_s
          }
          achieved_badges_for_total_check_in_counts = find_all_achieved_badge_statuses(user.badge_statuses_for_total_check_in_counts).map {|status|
            status[:badge].to_s
          }
          achieved_badges_for_total_poi_photo_counts = find_all_achieved_badge_statuses(user.badge_statuses_for_total_poi_photo_counts).map {|status|
            status[:badge].to_s
          }
          achieved_badges_for_total_poi_review_counts = find_all_achieved_badge_statuses(user.badge_statuses_for_total_poi_review_counts).map {|status|
            status[:badge].to_s
          }

          achieved_badges_for_total_points.each do |badge|
            total_user_badges_for_total_points_achieved[badge] += 1
          end
          achieved_badges_for_total_check_in_counts.each do |badge|
            total_user_badges_for_total_check_ins_achieved[badge] += 1
          end
          achieved_badges_for_total_poi_photo_counts.each do |badge|
            total_user_badges_for_total_poi_photos_achieved[badge] += 1
          end
          achieved_badges_for_total_poi_review_counts.each do |badge|
            total_user_badges_for_total_poi_reviews_achieved[badge] += 1
          end
        end

        render json: {
          total_points_badges:      Constants::BADGE_THRESHOLDS_FOR_TOTAL_NO_POINTS.map do |badge, threshold|
            {
              badge:     badge.to_s,
              count:     total_user_badges_for_total_points_achieved[badge.to_s] || 0,
              threshold:
            }
          end,
          total_check_ins_badges:   Constants::BADGE_THRESHOLDS_FOR_TOTAL_COUNTS_IN_CATEGORY.map do |badge, threshold|
            {
              badge:     badge.to_s,
              count:     total_user_badges_for_total_check_ins_achieved[badge.to_s] || 0,
              threshold:
            }
          end,
          total_poi_photos_badges:  Constants::BADGE_THRESHOLDS_FOR_TOTAL_COUNTS_IN_CATEGORY.map do |badge, threshold|
            {
              badge:     badge.to_s,
              count:     total_user_badges_for_total_poi_photos_achieved[badge.to_s] || 0,
              threshold:
            }
          end,
          total_poi_reviews_badges: Constants::BADGE_THRESHOLDS_FOR_TOTAL_COUNTS_IN_CATEGORY.map do |badge, threshold|
            {
              badge:     badge.to_s,
              count:     total_user_badges_for_total_poi_reviews_achieved[badge.to_s] || 0,
              threshold:
            }
          end
        }
      end

      private

      def find_all_achieved_badge_statuses(badge_statuses)
        badge_statuses.select {|badge_status|
          badge_status[:status] == "ACHIEVED"
        }
      end
    end
  end
end
