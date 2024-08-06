# frozen_string_literal: true

# rubocop:disable RSpec/VerifiedDoubles
require "rails_helper"

RSpec.describe UtilsController do
  describe "#geolocation" do
    context "when geolocation is successful" do
      it "returns JSON with latitude and longitude" do
        allow(request).to receive(:remote_ip).and_return("0.0.0.0")

        allow(Geocoder).to receive(:search).with("0.0.0.0").and_return([double(coordinates: [1.23, 4.56])])

        get :geolocation

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("lat")
        expect(json_response).to have_key("lon")
        expect(json_response["lat"]).to eq(1.23)
        expect(json_response["lon"]).to eq(4.56)
      end
    end

    context "when geolocation fails" do
      it "returns JSON with a not found message" do
        allow(request).to receive(:remote_ip).and_return("0.0.0.0")

        allow(Geocoder).to receive(:search).with("0.0.0.0").and_return([double(coordinates: [])])

        get :geolocation

        expect(response).to have_http_status(:not_found)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Location not found")
      end
    end
  end

  describe "#geolocation_with_ip_param" do
    context "when geolocation is successful" do
      it "returns JSON with latitude and longitude" do
        allow(Geocoder).to receive(:search).with("0.0.0.0").and_return([double(coordinates: [1.23, 4.56])])

        get :geolocation_with_ip_param, params: {ip: "0.0.0.0"}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("lat")
        expect(json_response).to have_key("lon")
        expect(json_response["lat"]).to eq(1.23)
        expect(json_response["lon"]).to eq(4.56)
      end
    end

    context "when geolocation fails" do
      it "returns JSON with a not found message" do
        allow(Geocoder).to receive(:search).with("invalid-ip").and_return([double(coordinates: [])])

        get :geolocation_with_ip_param, params: {ip: "invalid-ip"}

        expect(response).to have_http_status(:not_found)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Location not found")
      end
    end

    context "when IP parameter is missing" do
      it "returns JSON with bad request message" do
        get :geolocation_with_ip_param

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Bad request")
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles
