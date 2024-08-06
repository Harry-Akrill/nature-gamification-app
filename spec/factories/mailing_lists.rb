# frozen_string_literal: true

# == Schema Information
#
# Table name: mailing_list
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :mailing_list do
    # id { 1 }
    email { "test@example.com" }
    created_at { "23/06/2013" }
    updated_at { "24/06/2013" }
  end
end
