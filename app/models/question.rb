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
class Question < ApplicationRecord
  self.table_name = "questions"
end
