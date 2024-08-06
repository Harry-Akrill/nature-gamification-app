# frozen_string_literal: true

# == Schema Information
#
# Table name: poi_pictures
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poi_id     :bigint           not null
#  user_id    :bigint           not null
#
class PoiPicture < ApplicationRecord
  belongs_to :user
  belongs_to :poi

  has_one_attached :picture
  validates :picture, content_type: ["image/png", "image/jpeg"]

  def picture_id
    picture.attachment.blob_id if picture.attached?
  end
end
