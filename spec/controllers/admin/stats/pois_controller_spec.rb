# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Stats::PoisController do
  let(:app_visit) { create(:app_visit, email: "test@example.com", viewed_pois: [poi.id]) }
  let(:poi) { create(:poi) }

  before do
    allow(controller).to receive(:authorize_admin_controllers).and_return(true)
  end

  describe "#all" do
    before do
      app_visit.viewed_pois << poi.id
      get :all
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns correct json response" do
      json_response = response.parsed_body
      expect(json_response["email_grouped"]).not_to be_empty
      expect(json_response["session_id_grouped"]).not_to be_empty
      expect(json_response["pois_grouped_with_duplicates"]).not_to be_empty
      expect(json_response["app_visit_grouped"]).not_to be_empty
    end
  end
end
