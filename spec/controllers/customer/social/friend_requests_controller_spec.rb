# frozen_string_literal: true

require "rails_helper"
require "rspec-benchmark"
require "spec_helper"

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

RSpec.describe Customer::Social::FriendRequestsController do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friend_request) { create(:friend_request, user_id: user.id, friend_id: friend.id) }
  let(:incoming_friend_request) { create(:friend_request, user: friend, friend: user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "returns a list of incoming friend requests" do
      incoming_friend_request
      get :index
      expect(response).to be_successful
      expect(response.parsed_body["incoming"].length).to eq(1)
    end

    it "returns a list of outgoing friend requests" do
      friend_request
      get :index
      expect(response).to be_successful
      expect(response.parsed_body["outgoing"].length).to eq(1)
    end

    it "performs under 2 seconds under high data loads" do
      user = User.first
      1000.times do |i|
        friend = User.create!(email: "user#{i}@test.com", nickname: "nickname#{i}", description: "description#{i}",
                              password: "password", password_confirmation: "password")
        FriendRequest.create!(user:, friend:)
      end
      expect { get :index }.to perform_under(2000).ms
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new friend request" do
        expect {
          post :create, params: {friend_id: friend.id}
        }.to change(FriendRequest, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new friend request" do
        expect {
          post :create, params: {friend_id: nil}
        }.not_to change(FriendRequest, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    it "accepts a friend request" do
      patch :update, params: {id: friend_request.id}
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "DELETE #destroy" do
    it "deletes a friend request" do
      delete :destroy, params: {id: friend_request.id}
      expect(response).to have_http_status(:no_content)
    end
  end
end
