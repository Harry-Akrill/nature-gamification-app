# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  deactivated            :boolean          default(FALSE)
#  description            :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  jti                    :string           not null
#  nickname               :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  user_type              :integer          default("customer"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :jwt_cookie_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum user_type: {customer: 0, admin: 1, reporter: 2}
  validates :user_type, presence: true, inclusion: {in: User.user_types.keys}

  EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/
  validates :email, presence: true, format: {with: EMAIL_REGEX}

  validates :nickname, length: {minimum: 3}

  has_one_attached :profile_picture

  validates :profile_picture, content_type: ["image/png", "image/jpeg"]

  has_many :poi_comments

  has_many :favourites
  has_many :favourite_pois, through: :favourites, source: :poi

  has_many :check_ins
  has_many :checked_in_pois, through: :check_ins, source: :poi

  has_many :poi_pictures
  has_many :submitted_picture_poi, through: :poi_pictures, source: :poi

  has_many :posts
  has_many :likes

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :blocks
  has_many :blocked_users, through: :blocks, source: :blocked_user

  def active_for_authentication?
    super && !deactivated
  end

  def total_points
    points_for_check_ins = total_check_in_counts * Constants::POINTS_PER_POI_CHECK_IN
    points_for_photos = total_poi_photo_counts * Constants::POINTS_PER_NEW_POI_PHOTO
    points_for_reviews = total_poi_review_counts * Constants::POINTS_PER_NEW_POI_REVIEW

    points_for_check_ins + points_for_photos + points_for_reviews
  end

  def total_check_in_counts
    check_ins.count
  end

  def total_poi_photo_counts
    poi_pictures.count
  end

  def total_poi_review_counts
    poi_comments.count

  end

  def badge_statuses_for_total_points
    total = total_points
    previous_threshold = 0
    Constants::BADGE_THRESHOLDS_FOR_TOTAL_NO_POINTS.map do |badge, threshold|
      status = if total >= threshold
                 "ACHIEVED"
               elsif total >= previous_threshold
                 "IN PROGRESS"
               else
                 "LOCKED"
               end
      return_value = {badge:, status:, threshold:,
      previous_threshold:}
      previous_threshold = threshold
      return_value
    end
  end

  def badge_statuses_for_total_check_in_counts
    total = total_check_in_counts
    previous_threshold = 0
    Constants::BADGE_THRESHOLDS_FOR_TOTAL_COUNTS_IN_CATEGORY.map do |badge, threshold|
      status = if total >= threshold
                 "ACHIEVED"
               elsif total >= previous_threshold
                 "IN PROGRESS"
               else
                 "LOCKED"
               end
      return_value = {badge:, status:, threshold:,
      previous_threshold:}
      previous_threshold = threshold
      return_value
    end
  end

  def badge_statuses_for_total_poi_photo_counts
    total = total_poi_photo_counts
    previous_threshold = 0
    Constants::BADGE_THRESHOLDS_FOR_TOTAL_COUNTS_IN_CATEGORY.map do |badge, threshold|
      status = if total >= threshold
                 "ACHIEVED"
               elsif total >= previous_threshold
                 "IN PROGRESS"
               else
                 "LOCKED"
               end
      return_value = {badge:, status:, threshold:,
previous_threshold:}
      previous_threshold = threshold
      return_value
    end
  end

  def badge_statuses_for_total_poi_review_counts
    total = total_poi_review_counts
    previous_threshold = 0
    Constants::BADGE_THRESHOLDS_FOR_TOTAL_COUNTS_IN_CATEGORY.map do |badge, threshold|
      status = if total >= threshold
                 "ACHIEVED"
               elsif total >= previous_threshold
                 "IN PROGRESS"
               else
                 "LOCKED"
               end
      return_value = {badge:, status:, threshold:,
      previous_threshold:}
      previous_threshold = threshold
      return_value
    end
  end

  def remove_friend(friend, current_user)
    current_user.friends.destroy(friend)
  end
end
