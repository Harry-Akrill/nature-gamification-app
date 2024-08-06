# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reporter::StatsController do
  let(:reporter) { create(:user, user_type: "reporter") }
  let(:user) { create(:user, user_type: "customer") }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "#globe" do
    context "when the user is a reporter" do
      let(:current_user) { reporter }

      it "returns JSON data with all and unique visit details" do
        create(:landing_page_visit, country: "Country A", longitude: 10, latitude: 20)
        create(:landing_page_visit, country: "Country B", longitude: 30, latitude: 40)
        create(:landing_page_visit, country: "Country A", longitude: 10, latitude: 20)

        get :globe

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("all")
        expect(json_response["all"]).to be_an(Array)
        expect(json_response).to have_key("unique")
        expect(json_response["unique"]).to be_an(Array)

        expect(json_response["all"].size).to eq(3)
        # expect(json_response['unique'].size).to eq(2)
        expect(json_response["all"].first).to include("10.0", "20.0", 1)
        expect(json_response["unique"].first).to include("10.0", "20.0", 1)
      end
    end

    context "when unauthorized user" do
      let(:current_user) { user }

      it "renders a forbidden response" do
        get :globe

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "#all_visits" do
    context "when the user is an reporter" do
      let(:current_user) { reporter }

      it "returns JSON data with all and unique visit details" do
        create(:landing_page_visit, country: "Country A", created_at: 2.days.ago, time_spent_seconds: 120,
email_of_registered_user: "user1@example.com")
        create(:landing_page_visit, country: "Country B", created_at: 1.day.ago, time_spent_seconds: 180,
email_of_registered_user: nil)
        create(:landing_page_visit, country: "Country A", created_at: 3.days.ago, time_spent_seconds: 90,
email_of_registered_user: "user2@example.com")

        get :all_visits
        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("all")
        expect(json_response["all"]).to be_an(Array)
        expect(json_response).to have_key("unique")
        expect(json_response["unique"]).to be_an(Array)

        expect(json_response["all"].size).to eq(3)
      end
    end

    context "when unauthorized user" do
      let(:current_user) { user }

      before do
        get :all_visits
      end

      it "renders a unauthorised response" do
        get :all_visits

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "#route_visits" do
    context "when authorized reporter user" do
      let(:current_user) { reporter }

      it "returns JSON data with routes visited and registration statistics" do
        create(:landing_page_visit, session_id: "session1", path_to_registration: "/home/user1")
        create(:landing_page_visit, session_id: "session1", path_to_registration: "/register-interest")
        create(:landing_page_visit, session_id: "session2", path_to_registration: "/home/user2")
        create(:landing_page_visit, session_id: "session3", path_to_registration: "/features")
        create(:landing_page_visit, session_id: "session3", path_to_registration: "/pricing")

        get :route_visits

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("routes_visited")
        expect(json_response["routes_visited"]).to be_a(Hash)
        expect(json_response).to have_key("registrations")
        expect(json_response["registrations"]).to be_an(Integer)
        expect(json_response).to have_key("total_unique_visits")
        expect(json_response["total_unique_visits"]).to be_an(Integer)

        # expect(json_response['routes_visited']).to include('/home', '/register-interest', '/features', '/pricing')
        # expect(json_response['registrations']).to eq(1)
        expect(json_response["total_unique_visits"]).to eq(3)
      end
    end

    context "when unauthorized user" do
      let(:current_user) { user }

      before do
        get :route_visits
      end

      it "renders a unauthorised response" do
        get :route_visits

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "#overall_details" do
    context "when authorized reporter user" do
      let(:current_user) { reporter }

      it "returns JSON data with overall system details" do
        create(:question)
        create(:question, answer: "test")
        create(:mailing_list)
        create(:user, user_type: 0)
        create(:review, rating: 4, content: "hi there", author: "bob")
        create(:review, rating: 5, content: "this is a test review", author: "steve")

        get :overall_details

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("questions_asked")
        expect(json_response["questions_asked"]).to be_an(Integer)
        expect(json_response).to have_key("questions_answered")
        expect(json_response["questions_answered"]).to be_an(Integer)
        expect(json_response).to have_key("mailing_list_signups")
        expect(json_response["mailing_list_signups"]).to be_an(Integer)
        expect(json_response).to have_key("customer_users_in_system")
        expect(json_response["customer_users_in_system"]).to be_an(Integer)
        expect(json_response).to have_key("total_reviews")
        expect(json_response["total_reviews"]).to be_an(Integer)
        expect(json_response).to have_key("average_review_rating")

        expect(json_response["questions_asked"]).to eq(2)
        expect(json_response["questions_answered"]).to eq(2)
        expect(json_response["mailing_list_signups"]).to eq(1)
        expect(json_response["customer_users_in_system"]).to eq(1)
        expect(json_response["total_reviews"]).to eq(2)
        expect(json_response["average_review_rating"]).to eq("4.5")
      end
    end

    context "when unauthorized user" do
      let(:current_user) { user }

      before do
        get :overall_details
      end

      it "renders a unauthorised response" do
        get :overall_details

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
