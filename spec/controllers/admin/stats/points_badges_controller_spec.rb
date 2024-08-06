# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Stats::PointsBadgesController do
  let(:admin) { create(:user, user_type: "admin") }
  let!(:users) { create_list(:user, 3) }

  before do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe "GET #all" do
    before do
      get :all
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the correct structure" do
      json_response = response.parsed_body
      expect(json_response.keys).to contain_exactly("total_points_badges", "total_check_ins_badges",
                                                    "total_poi_photos_badges", "total_poi_reviews_badges")
    end

    it "returns the correct badge counts" do
      json_response = response.parsed_body
      expect(json_response["total_points_badges"].first.keys).to contain_exactly("badge", "count", "threshold")
      expect(json_response["total_check_ins_badges"].first.keys).to contain_exactly("badge", "count", "threshold")
      expect(json_response["total_poi_photos_badges"].first.keys).to contain_exactly("badge", "count", "threshold")
      expect(json_response["total_poi_reviews_badges"].first.keys).to contain_exactly("badge", "count", "threshold")
    end
  end
end
