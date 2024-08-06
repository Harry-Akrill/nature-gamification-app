# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  deactivated            :boolean          default(FALSE)
#  description            :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  jti                    :string           not null
#  nickname               :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  user_type              :integer          default("customer"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "rails_helper"

# RSpec.describe User do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
# rubocop:disable RSpec/NamedSubject
RSpec.describe User do
  subject {
    described_class.new(email: "test@example.com", nickname: "user", description: "description", password: "password",
                        user_type: "customer")
  }

  let(:user) { create(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      described_class.create!(email: "test@example.com", nickname: "user", description: "description",
                              password: "password", user_type: "customer")
      expect(subject).not_to be_valid
    end

    it "is not valid with an incorrectly formatted email" do
      subject.email = "testexample.com"
      expect(subject).not_to be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it "is not valid with a short password" do
      subject.password = "pass"
      expect(subject).not_to be_valid
    end

    it "is not valid without a user_type" do
      subject.user_type = nil
      expect(subject).not_to be_valid
    end

    it "raises an error with an invalid user_type" do
      expect { subject.user_type = "invalid" }.to raise_error(ArgumentError)
    end
  end

  describe "#active_for_authentication?" do
    context "when user is deactivated" do
      before do
        user.update(deactivated: true)
      end

      it "returns false" do
        expect(user.active_for_authentication?).to be(false)
      end
    end

    context "when user is not deactivated" do
      it "returns true" do
        expect(user.active_for_authentication?).to be(true)
      end
    end
  end
end

# rubocop:enable RSpec/NamedSubject
