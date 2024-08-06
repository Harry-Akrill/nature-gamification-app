# frozen_string_literal: true

# == Schema Information
#
# Table name: landing_page_visits
#
#  id                       :bigint           not null, primary key
#  country                  :string           not null
#  email_of_registered_user :string
#  ip_address               :string           not null
#  latitude                 :decimal(, )      not null
#  longitude                :decimal(, )      not null
#  path_to_registration     :text             default(""), not null
#  time_spent_seconds       :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  session_id               :string           not null
#
class LandingPageVisit < ApplicationRecord
  self.table_name = "landing_page_visits"
end
