# frozen_string_literal: true

# == Schema Information
#
# Table name: pois
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  features    :string           default([]), not null, is an Array
#  latitude    :float            not null
#  likes       :integer          default(0), not null
#  location    :string           not null
#  longitude   :float            not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_pois_on_name  (name) UNIQUE
#
require "rails_helper"

RSpec.describe Poi do
  pending "add some examples to (or delete) #{__FILE__}"
end
