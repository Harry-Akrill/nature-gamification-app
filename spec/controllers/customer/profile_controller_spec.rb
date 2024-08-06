# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer::ProfileController do
  let(:user) { create(:user, user_type: "customer") }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET #show" do
    context "with valid params" do
      let(:current_user) { user }

      before do
        get :show
      end

      it "returns a 200 response" do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe "PUT #update_user_profile" do
    context "with valid params" do
      let(:valid_attributes) {
        {nickname: "user2", description: "user description2"}
      }

      let(:current_user) { user }

      it "updates the requested user's profile" do
        put :update_user_profile, params: {user: valid_attributes}
        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        {nickname: "fs"}
      }

      let(:current_user) { user }

      it "does not update the user's profile" do
        put :update_user_profile, params: {user: invalid_attributes}
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "PUT #update_profile_picture" do
    context "with valid params" do
      let(:valid_picture) {
        Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/image0001.jpeg"), "image/jpeg")
      }

      let(:current_user) { user }

      it "updates the requested user's profile picture" do
        put :update_profile_picture, params: {profile_picture: valid_picture}
        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      let(:invalid_picture) {
        Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/invalid_picture.txt"), "text/plain")
      }

      let(:current_user) { user }

      it "does not update the user's profile picture" do
        put :update_profile_picture, params: {profile_picture: invalid_picture}
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
