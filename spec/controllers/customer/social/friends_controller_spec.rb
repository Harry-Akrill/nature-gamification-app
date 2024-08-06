# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer::Social::FriendsController do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    user.friends << friend
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(response.parsed_body).to eq([friend.as_json])
    end
  end

  describe "DELETE #destroy" do
    it "removes the friend from the user's friend list" do
      expect {
        delete :destroy, params: {id: friend.id}
      }.to change { user.friends.count }.by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
