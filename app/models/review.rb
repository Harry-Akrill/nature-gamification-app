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
class Review < ApplicationRecord
  self.table_name = "reviews"

  validates :content, :author, :rating, presence: true
end
