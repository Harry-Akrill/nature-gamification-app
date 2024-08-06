# frozen_string_literal: true

# == Schema Information
#
# Table name: favourites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poi_id     :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_favourites_on_user_id_and_poi_id  (user_id,poi_id) UNIQUE
#
class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :poi

  validates :user_id, uniqueness: {scope: :poi_id}
  validates :poi_id, uniqueness: {scope: :user_id}
end
