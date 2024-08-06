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

FactoryBot.define do
  factory :poi_picture do
  end
end
