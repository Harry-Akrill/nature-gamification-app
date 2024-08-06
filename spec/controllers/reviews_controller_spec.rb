# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReviewsController do
  let(:valid_attributes) {
    {content: "Great product!", author: "John Doe", rating: 5}
  }

  let(:invalid_attributes) {
    {content: "", author: "", rating: nil}
  }

  describe "GET #all_reviews" do
    it "returns a success response" do
      Review.create! valid_attributes
      get :all_reviews
      expect(response).to be_successful
    end
  end

  describe "POST #submit_review" do
    context "with valid params" do
      it "creates a new Review" do
        expect {
          post :submit_review, params: valid_attributes
        }.to change(Review, :count).by(1)
      end

      it "renders a JSON response with the new review" do
        post :submit_review, params: valid_attributes
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new review" do
        post :submit_review, params: invalid_attributes
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PUT #upvote_review" do
    it "upvotes a review" do
      review = Review.create! valid_attributes
      put :upvote_review, params: {id: review.to_param}
      review.reload
      expect(review.upvotes).to eq(1)
    end
  end

  describe "PUT #downvote_review" do
    it "downvotes a review" do
      review = Review.create! valid_attributes
      put :downvote_review, params: {id: review.to_param}
      review.reload
      expect(review.downvotes).to eq(1)
    end
  end

  describe "DELETE #cancel_downvote_review" do
    it "cancels the downvote to a review" do
      review = Review.create! valid_attributes
      put :downvote_review, params: {id: review.to_param}
      review.reload
      delete :cancel_downvote_review, params: {id: review.id}
      review.reload
      expect(review.downvotes).to eq(0)
    end
  end

  describe "DELETE #cancel_upvote_review" do
    it "cancels the upvote to a review" do
      review = Review.create! valid_attributes
      put :upvote_review, params: {id: review.to_param}
      review.reload
      delete :cancel_upvote_review, params: {id: review.id}
      review.reload
      expect(review.upvotes).to eq(0)
    end
  end
end
