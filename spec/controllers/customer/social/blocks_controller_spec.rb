# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer::Social::BlocksController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    before do
      user.blocks.create(blocked_user_id: other_user.id)
    end

    it "returns a list of blocked users" do
      get :index
      expect(response).to be_successful
      expect(response.parsed_body.length).to eq(1)
    end
  end

  describe "POST #block" do
    it "blocks a user" do
      post :block, params: {id: other_user.id}
      expect(response).to have_http_status(:no_content)
      expect(user.blocks.find_by(blocked_user_id: other_user.id)).to be_present
    end
  end

  describe "DELETE #unblock" do
    before do
      user.blocks.create(blocked_user_id: other_user.id)
    end

    it "unblocks a user" do
      delete :unblock, params: {id: other_user.id}
      expect(response).to be_successful
      expect(response.parsed_body["message"]).to eq("User unblocked successfully")
      expect(user.blocks.find_by(blocked_user_id: other_user.id)).to be_nil
    end

    it "returns an error when the block does not exist" do
      delete :unblock, params: {id: 9999}
      expect(response).to have_http_status(:not_found)
      expect(response.parsed_body["error"]).to eq("Block not found")
    end
  end
end
