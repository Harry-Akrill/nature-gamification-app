# frozen_string_literal: true

# spec/controllers/users/authentication_status_controller_spec.rb
require "rails_helper"

RSpec.describe Users::AuthenticationStatusController do
  describe "GET #index" do
    context "when the user is authenticated" do
      let(:authenticated_user) { User.create(user_type: "customer") }

      before do
        allow(controller).to receive(:authenticated?).and_return(true)
        sign_in authenticated_user # Sign in the user
        get :index
      end

      it "returns a 200 response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the user type" do
        expect(response.parsed_body["userType"]).to be(true) # Check for boolean value
      end
    end

    context "when the user is not authenticated" do
      before do
        allow(controller).to receive(:authenticated?).and_return(false)
        get :index
      end

      it "returns a 401 response" do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns "Not Authenticated" as the user type' do
        expect(response.parsed_body["userType"]).to eq("Not Authenticated")
      end
    end
  end
end
