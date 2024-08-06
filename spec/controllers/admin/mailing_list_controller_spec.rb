# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::MailingListController do
  let(:admin) { create(:user, user_type: "admin") }
  let(:user) { create(:user, user_type: "customer") }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET #index" do
    context "when the user is an admin" do
      let(:current_user) { admin }

      before do
        get :all_emails
      end

      it "returns a 200 response" do
        expect(response).to have_http_status :ok
      end
    end

    context "when the user is not an admin" do
      let(:current_user) { user }

      before do
        get :all_emails
      end

      it "returns a 401 response" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
