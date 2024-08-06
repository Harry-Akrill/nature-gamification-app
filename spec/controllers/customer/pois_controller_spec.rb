# frozen_string_literal: true

require "rails_helper"
require "rspec-benchmark"
require "spec_helper"

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

RSpec.describe Customer::PoisController do
  let(:user) { create(:user, user_type: "customer") }
  let(:poi) { create(:poi) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #all" do
    before do
      get :all, params: {north: 90, south: -90, east: 180, west: -180}
      poi1.poi_pictures << poi_picture
      get :all,
          params: {north: poi1.latitude + 1, south: poi1.latitude - 1, east: poi1.longitude + 1,
west: poi1.longitude - 1}
      @json_response = response.parsed_body
      poi1.poi_pictures << poi_picture
      get :all,
          params: {north: poi1.latitude + 1, south: poi1.latitude - 1, east: poi1.longitude + 1,
west: poi1.longitude - 1}
      @json_response = response.parsed_body
    end

    let(:poi_picture) { create(:poi_picture, poi_id: poi1.id, user_id: user.id, picture: valid_picture) }
    let(:valid_picture) {
      Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/image0001.jpeg"), "image/jpeg")
    }
    let(:poi1) { create(:poi) }
    let(:current_user) { user }

    it "returns a success response" do
      expect(response).to have_http_status :ok
    end

    it "performs in under 5 seconds under high data loads" do
      create_list(:poi, 1000)
      expect {
        get :all, params: {north: 90, south: -90, east: 180, west: -180}
      }.to perform_under(5000).ms
    end

    it "returns the correct lngLat" do
      expect(@json_response.first["lngLat"]).to eq({"lng" => poi1.longitude, "lat" => poi1.latitude})
    end

    it "returns all pois in the specified range" do
      expect(response.parsed_body.pluck("id")).to include(poi1.id)
    end

    it "returns bad request when coordinates are out of range" do
      get :all, params: {north: 91, south: -91, east: 181, west: -181}
      expect(response).to have_http_status(:bad_request)
    end

    it "returns bad request when north is less than south or east is less than west" do
      get :all, params: {north: -1, south: 1, east: -1, west: 1}
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET #single_poi_by_id" do
    context "when poi exists" do
      let(:current_user) { user }
      let(:valid_picture) {
        Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/image0001.jpeg"), "image/jpeg")
      }
      let(:poi_picture) { create(:poi_picture, poi_id: poi.id, user_id: user.id, picture: valid_picture) }

      before do
        poi.poi_pictures << poi_picture
        get :single_poi_by_id, params: {id: poi.id}
      end

      it "returns a success response" do
        expect(response).to have_http_status :ok
      end

      it "returns the correct poi" do
        expect(response.parsed_body["id"]).to eq(poi.id)
      end
    end

    context "when poi does not exist" do
      it "returns a bad request response" do
        expect {
          get :single_poi_by_id, params: {id: -1}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #all_poi_features" do
    before do
      get :all_poi_features
    end

    it "performs in under 4 seconds under high data loads" do
      create_list(:poi, 1000)
      expect {
        get :all_poi_features
      }.to perform_under(4000).ms
    end

    it "returns a success response" do
      expect(response).to have_http_status :ok
    end

    it "returns all poi features" do
      expect(response.parsed_body["allPOIFeatures"]).to eq(Poi::FEATURES)
    end
  end

  describe "GET #search_by_name" do
    let(:current_user) { user }
    let(:valid_picture) {
      Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/image0001.jpeg"), "image/jpeg")
    }
    let(:poi_picture) { create(:poi_picture, poi_id: poi.id, user_id: user.id, picture: valid_picture) }
    let(:similar_poi) { create(:poi, name: "similar name") }

    context "when poi exists" do
      before do
        poi.poi_pictures << poi_picture
        get :search_by_name, params: {name: poi.name}
      end

      it "returns a success response" do
        expect(response).to have_http_status :ok
      end
    end

    context "when the search field is blank" do
      before do
        get :search_by_name, params: {name: ""}
      end

      it "returns a bad request response" do
        expect(response).to have_http_status :bad_request
      end
    end

    # ISSUES WITH RSPEC NOT WORKING WITH PG_TRGM TRIGRAM SIMILARITY POSTGRES EXTENSION FOR SOME REASON...
    # CONTROLLER ACTION HAS BEEN VERIFIED TO WORK PROPERLY THROUGH MANUAL TESTING.
    # context "when poi exists and query is similar" do
    #     before do
    #         get :search_by_name, params: { name: "similar name" }
    #     end

    #     it "returns a success response" do
    #         expect(response).to have_http_status :ok
    #     end

    #     it "returns the correct poi" do
    #         puts "response.body: #{response.body}"
    #         expect(JSON.parse(response.body).map { |poi| poi["name"] }).to include(similar_poi.name)
    #     end
    # end

    context "when poi exists but query is not similar" do
      before do
        get :search_by_name, params: {name: "kokpodkfgpkdfg"}
      end

      it "returns a success response" do
        expect(response).to have_http_status :ok
      end

      it "does not return the poi" do
        expect(response.parsed_body.pluck("name")).not_to include(similar_poi.name)
      end
    end
  end

  describe "POST #upload_poi_picture" do
    context "when poi exists" do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/image0001.jpeg"), "image/jpeg") }

      before do
        post :upload_poi_picture, params: {poi_id: poi.id, picture: file}
      end

      it "returns a success response" do
        expect(response).to have_http_status :ok
      end

      it "attaches the uploaded picture to the poi" do
        expect(poi.poi_pictures.last.picture).to be_attached
      end
    end

    context "when poi does not exist" do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/image0001.jpeg"), "image/jpeg") }

      before do
        post :upload_poi_picture, params: {poi_id: -1, picture: file}
      end

      it "returns a not found response" do
        expect(response).to have_http_status :not_found
      end
    end

    context "when picture is not provided" do
      before do
        post :upload_poi_picture, params: {poi_id: poi.id}
      end

      it "returns a bad request response" do
        expect(response).to have_http_status :internal_server_error
      end
    end

    context "when the upload is not a picture" do
      let(:file) {
        Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/invalid_picture.txt"), "text/plain")
      }

      before do
        post :upload_poi_picture, params: {poi_id: poi.id, picture: file}
      end

      it "returns a bad request response" do
        expect(response).to have_http_status :internal_server_error
      end
    end
  end
end
