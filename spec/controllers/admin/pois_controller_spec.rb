# frozen_string_literal: true

require "rails_helper"
require "rspec-benchmark"
require "spec_helper"

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

RSpec.describe Admin::PoisController do
  let(:user) { create(:user, user_type: "customer") }
  let(:admin) { create(:user, user_type: "admin") }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET #all_pois" do
    context "when an admin" do
      let(:current_user) { admin }

      before do
        get :all_pois
      end

      it "returns a success response" do
        expect(response).to have_http_status :ok
      end

      it "performs in under 3 seconds under high data loads" do
        create_list(:poi, 1000)
        expect {
          get :all_pois
        }.to perform_under(3000).ms
      end
    end

    context "when a user" do
      let(:current_user) { user }

      before do
        get :all_pois
      end

      it "returns a unauthorised response" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "#all_poi_feature_options" do
    let(:current_user) { admin }

    it "returns all POI feature options" do
      get :all_poi_feature_options
      expect(response.body).to eq({allPOIFeatureOptions: Poi::FEATURES}.to_json)
    end
  end

  describe "POST #create_poi" do
    context "with valid params" do
      let(:valid_attributes) {
        {
          description: "A poi",
          features:    Poi::FEATURES,
          latitude:    50,
          likes:       100,
          location:    "location",
          longitude:   4,
          name:        "testname"
        }
      }

      let(:current_user) { admin }

      it "creates a new Poi" do
        expect {
          post :create_poi, params: {poi: valid_attributes}
        }.to change(Poi, :count).by(1)
      end
    end

    context "with invalid longitude" do
      let(:invalid_attributes) {
        {
          description: "A poi",
          features:    Poi::FEATURES,
          latitude:    80,
          likes:       10,
          location:    "location",
          longitude:   200,
          name:        "testname"
        }
      }

      let(:current_user) { admin }

      it "does not create a new Poi" do
        expect {
          post :create_poi, params: {poi: invalid_attributes}
        }.not_to change(Poi, :count)
      end
    end

    context "with invalid latitude" do
      let(:invalid_attributes) {
        {
          description: "A poi",
          features:    Poi::FEATURES,
          latitude:    100,
          likes:       10,
          location:    "location",
          longitude:   100,
          name:        "testname"
        }
      }

      let(:current_user) { admin }

      it "does not create a new Poi" do
        expect {
          post :create_poi, params: {poi: invalid_attributes}
        }.not_to change(Poi, :count)
      end
    end

    context "with too short name length" do
      let(:invalid_attributes) {
        {
          description: "A poi",
          features:    Poi::FEATURES,
          latitude:    100,
          likes:       10,
          location:    "location",
          longitude:   100,
          name:        "As"
        }
      }

      let(:current_user) { admin }

      it "does not create a new Poi" do
        expect {
          post :create_poi, params: {poi: invalid_attributes}
        }.not_to change(Poi, :count)
      end
    end

    context "with invalid name regex" do
      let(:invalid_attributes) {
        {
          description: "A poi",
          features:    Poi::FEATURES,
          latitude:    100,
          likes:       10,
          location:    "location",
          longitude:   100,
          name:        "As,sd.s"
        }
      }

      let(:current_user) { admin }

      it "does not create a new Poi" do
        expect {
          post :create_poi, params: {poi: invalid_attributes}
        }.not_to change(Poi, :count)
      end
    end

    context "when the user is not an admin" do
      let(:current_user) { user }

      it "returns a unauthorised response" do
        post :create_poi, params: {poi: {}}
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "PUT #edit_poi" do
    context "with valid params" do
      let(:valid_attributes) {
        {
          name:        "test",
          description: "A poi",
          features:    Poi::FEATURES,
          latitude:    50,
          location:    "location",
          longitude:   4
        }
      }
      let(:new_attributes) {
        {
          name:        "test2",
          description: "A poinew",
          features:    Poi::FEATURES.slice(0, 1),
          latitude:    54,
          location:    "testloc2",
          longitude:   77
        }
      }

      let(:current_user) { admin }

      it "updates the poi" do
        poi = Poi.create! valid_attributes
        post :edit_poi, params: {id: poi.to_param}.merge(new_attributes)
        poi.reload
        expect(poi.name).to eq(new_attributes[:name])
        expect(poi.description).to eq(new_attributes[:description])
        expect(poi.features).to eq(new_attributes[:features])
        expect(poi.latitude).to eq(new_attributes[:latitude])
        expect(poi.location).to eq(new_attributes[:location])
        expect(poi.longitude).to eq(new_attributes[:longitude])
      end
    end
  end

  describe "DELETE #delete_poi" do
    context "when an admin" do
      let(:valid_attributes) {
        {
          description: "A poi",
          features:    Poi::FEATURES,
          latitude:    50,
          likes:       100,
          location:    "location",
          longitude:   4,
          name:        "test"
        }
      }

      let(:current_user) { admin }

      it "deletes the poi" do
        poi = Poi.create! valid_attributes
        expect {
          delete :delete_poi, params: {id: poi.to_param}
        }.to change(Poi, :count).by(-1)
      end
    end

    context "when a user" do
      let(:current_user) { user }

      it "returns a unauthorised response" do
        delete :delete_poi, params: {id: 1}
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
