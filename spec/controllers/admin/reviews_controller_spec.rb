# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ReviewsController do
  let(:admin) { create(:user, user_type: "admin") }
  let(:user) { create(:user, user_type: "customer") }
  let(:review) { create(:review, author: "test", content: "content", rating: 5) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET #index" do
    context "when the user is an admin" do
      let(:current_user) { admin }

      before do
        get :all_reviews
      end

      it "returns a 200 response" do
        expect(response).to have_http_status :ok
      end
    end

    context "when the user is not an admin" do
      let(:current_user) { user }

      before do
        get :all_reviews
      end

      it "returns a 401 response" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE #delete_review" do
    let(:review_params) { {id: review.id} }

    context "when the user is an admin" do
      let(:current_user) { admin }

      before do
        delete :delete_review, params: review_params
      end

      it "deletes the review and returns a 200 response" do
        expect(response).to have_http_status :ok
        expect(response.parsed_body["message"]).to eq "Deleted review successfully"
        expect(Review.find_by(id: review.id)).to be_nil
      end
    end

    context "when the user is not an admin" do
      let(:current_user) { user }

      before do
        delete :delete_review, params: review_params
      end

      it "does not delete the review and returns a 401 response" do
        expect(response).to have_http_status :unauthorized
        expect(Review.find_by(id: review.id)).not_to be_nil
      end
    end
  end
end
