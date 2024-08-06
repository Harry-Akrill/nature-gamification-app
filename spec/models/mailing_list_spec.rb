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
require "rails_helper"
# rubocop:disable RSpec/NamedSubject
RSpec.describe MailingList do
  subject { described_class.new(email: "test@example.com") }

  describe "validations" do
    it "is not valid with an incorrectly formatted email" do
      subject.email = "testexample.com"
      expect(subject).not_to be_valid
    end
  end
end
# rubocop:enable RSpec/NamedSubject
