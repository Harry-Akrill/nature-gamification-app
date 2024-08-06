# frozen_string_literal: true

# == Schema Information
#
# Table name: pois
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  features    :string           default([]), not null, is an Array
#  latitude    :float            not null
#  likes       :integer          default(0), not null
#  location    :string           not null
#  longitude   :float            not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_pois_on_name  (name) UNIQUE
#
class Poi < ApplicationRecord
  self.table_name = "pois"

  FEATURES = [
    "Natural Landmark",
    "Scenic Viewpoint",
    "Statue",
    "Historical Site",
    "Cultural Attraction",
    "Recreational Area",
    "Educational Institution",
    "Shopping District",
    "Food and Drink",
    "Entertainment Venue",
    "Water Fountain",
    "Pond"
  ].freeze

  validates :latitude, numericality: {greater_than_or_equal_to: -90, less_than_or_equal_to: 90}
  validates :longitude, numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}
  validates :name, length: {minimum: 3}, format: {with: /\A[a-z0-9 ]+\z/i}

  has_many :comments

  has_many :favourites
  has_many :favourite_users, through: :favourites, source: :user

  has_many :check_ins
  has_many :checked_in_users, through: :check_ins, source: :user

  has_many :poi_pictures
  has_many :submitted_picture_user, through: :poi_pictures, source: :user

  validates_each :features do |record, attr, value|
    value.each do |feature|
      record.errors.add(attr, "contains invalid feature") unless FEATURES.include?(feature)
    end
  end
end
