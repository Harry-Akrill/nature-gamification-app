# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer::PointsBadgesController do
  let(:user) { create(:user, user_type: "customer") }
  let(:poi) { create(:poi) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "#all" do
    let(:current_user) { user }

    context "with valid params" do
      it "returns all points and badges data for the user" do
        get :all
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include(
          "totalPoints",
          "totalCheckInCounts",
          "totalPoiPhotoCounts",
          "totalPoiReviewCounts",
          "badgeStatusesForTotalPoints",
          "badgeStatusesForTotalCheckInCounts",
          "badgeStatusesForTotalPoiPhotoCounts",
          "badgeStatusesForTotalPoiReviewCounts"
        )
      end

      it "returns correct points and badges data for the user" do
        allow(user).to receive(:total_points).and_return(100)

        get :all

        parsed_response = response.parsed_body
        expect(parsed_response["totalPoints"]).to eq(100)
      end
    end

    context "with invalid params" do
      let(:current_user) { nil }

      it "returns error when user is not authenticated" do
        get :all
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#avatar_dropdown_current_total_points" do
    let(:current_user) { user }

    context "with valid params" do
      it "returns the current total points and badge status for the user" do
        get :avatar_dropdown_current_total_points
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include(
          "totalPoints",
          "badge",
          "threshold",
          "previousThreshold"
        )
      end

      it "returns correct total points and badge data for the user" do
        allow(user).to receive(:total_points).and_return(100)
        get :avatar_dropdown_current_total_points
        parsed_response = response.parsed_body
        expect(parsed_response["totalPoints"]).to eq(100)
      end
    end

    context "with invalid params" do
      let(:current_user) { nil }

      it "returns error when user is not authenticated" do
        get :avatar_dropdown_current_total_points
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#all_in_progress" do
    let(:current_user) { user }

    context "with valid params" do
      it "returns all in progress badges for the user" do
        get :all_in_progress
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include(
          "total_points_in_progress",
          "total_check_ins_in_progress",
          "total_poi_photos_in_progress",
          "total_poi_reviews_in_progress"
        )
      end

      #            it 'returns correct in progress badges for the user' do
      #                user = double('User', total_points_in_progress: 100)
      #
      #                allow(controller).to receive(:current_user).and_return(user)
      #
      #                get :all_in_progress
      #
      #                parsed_response = JSON.parse(response.body)
      #                expect(parsed_response['totalPointsInProgress']).to eq(100)
      #            end
    end

    context "with invalid params" do
      let(:current_user) { nil }

      it "returns error when user is not authenticated" do
        get :all_in_progress
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
