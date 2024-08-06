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

FactoryBot.define do
  factory :poi_comment do
    user
    poi
    text { "This is a sample comment." }
    rating { rand(1..5) }
    reported { false }

    # If you want to create reported comments in your tests
    trait :reported do
      reported { true }
    end
  end
end
