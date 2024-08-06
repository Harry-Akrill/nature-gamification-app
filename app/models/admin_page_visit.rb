# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_page_visits
#
#  id                 :bigint           not null, primary key
#  ip_address         :string           not null
#  time_spent_seconds :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  session_id         :string           not null
#
class AdminPageVisit < ApplicationRecord
  self.table_name = "admin_page_visits"
end
