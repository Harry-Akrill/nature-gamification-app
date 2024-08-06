# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer::Social::CommentsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_comment) { create(:post, user:) }
  let(:comment) { create(:comment, user_id: user.id, post_id: post_comment.id) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    before do
      comment
    end

    it "returns a list of comments for a post" do
      get :index, params: {post_id: post_comment.id}
      expect(response).to be_successful
      expect(response.parsed_body.length).to eq(1)
    end
  end

  describe "POST #create" do
    it "creates a comment for a post" do
      post :create, params: {post_id: post_comment.id, comment: {content: "Test comment"}}
      expect(response).to have_http_status(:created)
      expect(response.parsed_body["content"]).to eq("Test comment")
    end

    it "returns unprocessable entity status when comment is invalid" do
      post :create, params: {post_id: post_comment.id, comment: {content: ""}}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH #update" do
    it "updates a comment" do
      patch :update, params: {post_id: post_comment.id, id: comment.id, comment: {content: "Updated comment"}}
      expect(response).to be_successful
      expect(response.parsed_body["content"]).to eq("Updated comment")
    end

    it "returns unprocessable entity status when update is invalid" do
      patch :update, params: {post_id: post_comment.id, id: comment.id, comment: {content: ""}}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    before do
      comment
    end

    it "deletes a comment" do
      expect {
        delete :destroy, params: {post_id: post_comment.id, id: comment.id}
      }.to change(Comment, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
