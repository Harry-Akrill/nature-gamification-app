# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::LandingPageController do
  describe "#register_new_page_visit" do
    let(:valid_coords) { {lat: 40.7128, lon: -74.0060} }
    let(:valid_country) { "United States" }

    before do
      allow(controller).to receive_messages(geolocation_from_ip: valid_coords, country_from_ip: valid_country)
    end

    context "with valid geolocation and country" do
      it "creates a new LandingPageVisit, assigns session[:visit_id], and returns a success message" do
        expect {
          post :register_new_page_visit
        }.to change(LandingPageVisit, :count).by(1)

        expect(session[:visit_id]).to be_present

        json_response = response.parsed_body
        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Registered new visit successfully")
      end
    end

    context "with invalid geolocation" do
      before { allow(controller).to receive(:geolocation_from_ip).and_return(nil) }

      it "renders a bad request response" do
        post :register_new_page_visit

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid country" do
      before { allow(controller).to receive(:country_from_ip).and_return(nil) }

      it "renders a bad request response" do
        post :register_new_page_visit

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit is not valid" do
      before { allow_any_instance_of(LandingPageVisit).to receive(:valid?).and_return(false) }

      it "renders an internal server error response" do
        post :register_new_page_visit

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "#register_new_page_visit_with_ip_param" do
    let(:valid_coords) { {lat: 40.7128, lon: -74.0060} }
    let(:valid_country) { "United States" }

    before do
      allow(controller).to receive_messages(geolocation_from_ip: valid_coords, country_from_ip: valid_country)
    end

    context "with valid IP parameter, geolocation, and country" do
      it "creates a new LandingPageVisit, assigns session[:visit_id], and returns a success message" do
        expect {
          post :register_new_page_visit_with_ip_param, params: {ip: "192.168.1.1"}
        }.to change(LandingPageVisit, :count).by(1)

        expect(session[:visit_id]).to be_present

        json_response = response.parsed_body
        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Registered new visit successfully")
      end
    end

    context "with missing IP parameter" do
      it "renders a bad request response" do
        post :register_new_page_visit_with_ip_param

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid IP parameter" do
      before { allow(controller).to receive(:geolocation_from_ip).and_return(nil) }

      it "renders a bad request response" do
        post :register_new_page_visit_with_ip_param, params: {ip: "sdfokokndkdn"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with valid IP parameter but invalid geolocation" do
      before { allow(controller).to receive(:geolocation_from_ip).and_return(nil) }

      it "renders a bad request response" do
        post :register_new_page_visit_with_ip_param, params: {ip: "192.168.1.1"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with valid IP parameter but invalid country" do
      before { allow(controller).to receive(:country_from_ip).and_return(nil) }

      it "renders a bad request response" do
        post :register_new_page_visit_with_ip_param, params: {ip: "192.168.1.1"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit is not valid" do
      before { allow_any_instance_of(LandingPageVisit).to receive(:valid?).and_return(false) }

      it "renders an internal server error response" do
        post :register_new_page_visit_with_ip_param, params: {ip: "192.168.1.1"}

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "#update_page_visit" do
    let(:valid_time_spent_seconds) { 120 }
    let(:visit_id) { 1 }

    context "with valid parameters" do
      let(:visit_id) { 1 }

      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id, session_id: session.id)
      end

      it "updates the page visit and returns a success message" do
        post :update_page_visit, params: {time_spent_seconds: valid_time_spent_seconds}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Page visit updated successfully")

        updated_page_visit = LandingPageVisit.find(visit_id)
        expect(updated_page_visit.time_spent_seconds).to eq(valid_time_spent_seconds)
        expect(updated_page_visit.session_id.to_s).to eq(session.id.to_s)
      end
    end

    context "with missing time_spent_seconds parameter" do
      it "renders a bad request response" do
        post :update_page_visit

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid time_spent_seconds parameter" do
      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: "invalid_time"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with negative time_spent_seconds parameter" do
      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: -10}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with missing visit_id in session" do
      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: valid_time_spent_seconds}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid visit_id in session" do
      before { session[:visit_id] = "invalid_id" }

      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: valid_time_spent_seconds}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit does not exist with the specified visit_id" do
      before { session[:visit_id] = visit_id }

      it "renders a bad request response" do
        post :update_page_visit, params: {time_spent_seconds: valid_time_spent_seconds}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit is not valid" do
      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id)
        allow_any_instance_of(LandingPageVisit).to receive(:valid?).and_return(false)
      end

      it "renders an internal server error response" do
        post :update_page_visit, params: {time_spent_seconds: valid_time_spent_seconds}

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "#path_to_registration_append" do
    let(:valid_path) { "/solution" }
    let(:visit_id) { 1 }

    context "with valid parameters and path append" do
      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id)
      end

      it "appends the path to registration and returns a success message" do
        post :path_to_registration_append, params: {path: valid_path}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Path appended successfully")

        updated_page_visit = LandingPageVisit.find(visit_id)
        expect(updated_page_visit.path_to_registration).to eq(valid_path)
      end
    end

    context "with missing path parameter" do
      it "renders a bad request response" do
        post :path_to_registration_append

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid path parameter" do
      it "renders a bad request response" do
        post :path_to_registration_append, params: {path: 123}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with missing visit_id in session" do
      it "renders a bad request response" do
        post :path_to_registration_append, params: {path: valid_path}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid visit_id in session" do
      before { session[:visit_id] = "invalid_id" }

      it "renders a bad request response" do
        post :path_to_registration_append, params: {path: valid_path}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit does not exist with the specified visit_id" do
      before { session[:visit_id] = visit_id }

      it "renders a bad request response" do
        post :path_to_registration_append, params: {path: valid_path}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when path is already appended" do
      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id, path_to_registration: "/home")
      end

      it "renders a bad request response" do
        post :path_to_registration_append, params: {path: "/home"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit is not valid" do
      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id)
        allow_any_instance_of(LandingPageVisit).to receive(:valid?).and_return(false)
      end

      it "renders an internal server error response" do
        post :path_to_registration_append, params: {path: valid_path}

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "#registration_completed" do
    let(:valid_email) { "user@example.com" }
    let(:visit_id) { 1 }

    context "with valid parameters and successful registration" do
      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id)
      end

      it "records the registration and returns a success message" do
        post :registration_completed, params: {email: valid_email}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Registration recorded successfully")

        updated_page_visit = LandingPageVisit.find(visit_id)
        expect(updated_page_visit.email_of_registered_user).to eq(valid_email)
      end
    end

    context "with invalid email parameter" do
      it "renders a bad request response" do
        post :registration_completed, params: {email: "invalid_email"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid visit_id in session" do
      before { session[:visit_id] = "invalid_id" }

      it "renders a bad request response" do
        post :registration_completed, params: {email: valid_email}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit does not exist with the specified visit_id" do
      before { session[:visit_id] = visit_id }

      it "renders a bad request response" do
        post :registration_completed, params: {email: valid_email}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when registration email is not valid" do
      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id)
      end

      it "renders a bad request response" do
        post :registration_completed, params: {email: "invalid_email"}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when LandingPageVisit is not valid" do
      before do
        session[:visit_id] = visit_id
        create(:landing_page_visit, id: visit_id)
        allow_any_instance_of(LandingPageVisit).to receive(:valid?).and_return(false)
      end

      it "renders an internal server error response" do
        post :registration_completed, params: {email: valid_email}

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
