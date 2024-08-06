# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  author     :string           default(""), not null
#  content    :text             default(""), not null
#  downvotes  :integer          default(0), not null
#  rating     :integer          not null
#  upvotes    :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :review do
    # id { 1 }
    created_at { "23/06/2013" }
    updated_at { "24/06/2013" }
  end
end
