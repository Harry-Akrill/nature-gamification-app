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
class MailingList < ApplicationRecord
  # rubocop:disable Rails/UniqueValidationWithoutIndex
  self.table_name = "mailing_list"
  validates :email, presence: true, uniqueness: true,
format: {with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/}

  def self.record_email(email)
    new_entry = new(email:)
    return false unless new_entry.valid?

    new_entry.save
    true
  end
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end
