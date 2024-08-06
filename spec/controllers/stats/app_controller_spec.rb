# frozen_string_literal: true

RSpec.describe Stats::AppController do
  let(:user) { create(:user, user_type: "customer") }
  let(:admin) { create(:user, user_type: "admin") }
  let(:current_user) { user }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "#register_new_page_visit" do
    context "with valid geolocation" do
      let(:valid_coords) { {lat: 23.456, lon: 45.678} }
      let(:valid_country) { "GB" }

      before do
        allow(controller).to receive(:geolocation_from_ip).with(request.remote_ip).and_return(valid_coords)
        allow(controller).to receive(:country_from_ip).with(request.remote_ip).and_return(valid_country)
      end

      it "registers a new page visit and returns a success message" do
        post :register_new_page_visit

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Registered new visit successfully")

        expect(session[:visit_id]).not_to be_nil

        created_page_visit = AppVisit.find(session[:visit_id])
        expect(created_page_visit).to be_valid
      end
    end

    context "with missing geolocation" do
      before do
        allow(controller).to receive(:geolocation_from_ip).with(request.remote_ip).and_return(nil)
        allow(controller).to receive(:country_from_ip).with(request.remote_ip).and_return(nil)
      end

      it "renders a bad request response" do
        post :register_new_page_visit

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when AppVisit is not valid" do
      let(:valid_coords) { {lat: 23.456, lon: 45.678} }
      let(:valid_country) { "GB" }

      before do
        allow(controller).to receive(:geolocation_from_ip).with(request.remote_ip).and_return(valid_coords)
        allow(controller).to receive(:country_from_ip).with(request.remote_ip).and_return(valid_country)
        allow_any_instance_of(AppVisit).to receive(:valid?).and_return(false)
      end

      it "renders an internal server error response" do
        post :register_new_page_visit

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "#register_new_page_visit_with_ip_param" do
    let(:valid_ip) { "31.94.30.32" }
    let(:valid_coords) { {lat: 23.456, lon: 45.678} }
    let(:valid_country) { "GB" }

    context "with valid IP and geolocation" do
      before do
        allow(controller).to receive(:geolocation_from_ip).with(valid_ip).and_return(valid_coords)
        allow(controller).to receive(:country_from_ip).with(valid_ip).and_return(valid_country)
      end

      it "registers a new page visit and returns a success message" do
        post :register_new_page_visit_with_ip_param, params: {ip: valid_ip}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Registered new visit successfully")

        expect(session[:visit_id]).not_to be_nil

        created_page_visit = AppVisit.find(session[:visit_id])
        expect(created_page_visit).to be_valid
      end
    end

    context "with missing IP parameter" do
      before do
        allow(controller).to receive(:geolocation_from_ip).with(valid_ip).and_return(valid_coords)
        allow(controller).to receive(:country_from_ip).with(valid_ip).and_return(valid_country)
      end

      it "renders a bad request response" do
        post :register_new_page_visit_with_ip_param

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid IP parameter" do
      it "renders a bad request response" do
        post :register_new_page_visit_with_ip_param, params: {ip: "invalid_ip"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with missing geolocation" do
      before do
        allow(controller).to receive(:geolocation_from_ip).with(valid_ip).and_return(nil)
      end

      it "renders a bad request response" do
        post :register_new_page_visit_with_ip_param, params: {ip: valid_ip}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when AppVisit is not valid" do
      let(:valid_ip) { "31.94.30.32" }
      let(:valid_coords) { {lat: 23.456, lon: 45.678} }
      let(:valid_country) { "GB" }

      before do
        allow(controller).to receive(:geolocation_from_ip).with(valid_ip).and_return(valid_coords)
        allow(controller).to receive(:country_from_ip).with(valid_ip).and_return(valid_country)
        allow_any_instance_of(AppVisit).to receive(:valid?).and_return(false)
      end

      it "renders an internal server error response" do
        post :register_new_page_visit_with_ip_param, params: {ip: valid_ip}

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "#update_page_visit" do
    let(:valid_visit_id) { 1 }

    context "with valid parameters" do
      before do
        session[:visit_id] = valid_visit_id
        create(:app_visit, id: valid_visit_id, session_id: session.id)
      end

      it "updates the page visit and returns a success message" do
        post :update_page_visit, params: {time_spent_seconds: 120}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Page visit updated successfully")
        updated_page_visit = AppVisit.find(valid_visit_id)
        expect(updated_page_visit.time_spent_seconds).to eq(120)
      end
    end

    context "with invalid time_spent_seconds parameter" do
      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: "invalid"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with negative time_spent_seconds parameter" do
      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: -5}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with missing visit_id in session" do
      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: 120}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when AppVisit is not valid" do
      before do
        session[:visit_id] = valid_visit_id
        create(:app_visit, id: valid_visit_id, session_id: session.id)
        allow_any_instance_of(AppVisit).to receive(:valid?).and_return(false)
      end

      it "renders an internal server error response" do
        post :update_page_visit, params: {time_spent_seconds: 120}

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
