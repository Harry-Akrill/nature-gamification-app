# frozen_string_literal: true

require "rails_helper"
require "rspec-benchmark"
require "spec_helper"

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

RSpec.describe Customer::PoiCommentsController do
  let(:user) { create(:user, user_type: "customer") }
  let(:poi) { create(:poi) }
  let(:comment) { create(:poi_comment, user:, poi:, reported: false) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "#all" do
    it "returns http success" do
      get :all, params: {poiId: poi.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "#create" do
    it "creates a new comment" do
      post :create, params: {poi_comment: {poi_id: poi.id, text: "Test comment", rating: 5}}
      expect(response).to have_http_status(:created)
      expect(PoiComment.last.text).to eq("Test comment")
    end

    it "returns an error for invalid POI ID" do
      post :create, params: {poi_comment: {poi_id: 999, text: "Test comment", rating: 5}}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Invalid POI ID")
    end
  end

  describe "#report" do
    it "reports a comment" do
      put :report, params: {id: comment.id, reported: true}
      expect(response).to have_http_status(:ok)
      expect(PoiComment.find(comment.id).reported).to be_truthy
    end
  end

  # describe "#get_total_comment_user" do
  #   it "returns the total number of comments for the current user" do
  #     get :get_total_comment_user

  #     expect(JSON.parse(response.body)["total_comments"]).to eq(user.poi_comments.count)
  #   end
  # end
end
