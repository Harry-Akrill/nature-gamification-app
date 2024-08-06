# frozen_string_literal: true

# == Schema Information
#
# Table name: poi_comments
#
#  id         :bigint           not null, primary key
#  rating     :integer
#  reported   :boolean          default(FALSE)
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poi_id     :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_poi_comments_on_poi_id   (poi_id)
#  index_poi_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (poi_id => pois.id)
#  fk_rails_...  (user_id => users.id)
#
class PoiComment < ApplicationRecord
  belongs_to :user
  belongs_to :poi

  validates :text, presence: true
  validates :rating, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 5}
end
