# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailingListController do
  let(:email) { create(:mailinglist, email: "test@test.com") }

  describe "#submit_email" do
    context "with a valid email" do
      let(:valid_email) { "test_email@test.com" }

      it "creates a new mailinglist item and returns a success message" do
        post :submit_email, params: {email: valid_email}
        expect(response).to have_http_status :ok
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Email recorded successfully")
      end
    end

    context "with a invalid email" do
      let(:invalid_email) { "test_emailtest.com" }

      it "returns an error message" do
        post :submit_email, params: {email: invalid_email}
        expect(response).to have_http_status(:bad_request)
      end

      it "does not create a new mailinglist item" do
        expect {
          post :submit_email, params: {email: invalid_email}
        }.not_to change(MailingList, :count)
      end
    end
  end
end
