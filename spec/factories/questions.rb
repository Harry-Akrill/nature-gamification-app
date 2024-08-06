# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  answer     :text
#  downvotes  :integer          default(0), not null
#  question   :text             default(""), not null
#  upvotes    :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :question do
    # id { 1 }
    question { "question123" }
    answer { "answer123" }
  end
end
