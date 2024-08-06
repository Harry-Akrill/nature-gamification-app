# frozen_string_literal: true

require "rails_helper"
require "rspec-benchmark"
require "spec_helper"

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

RSpec.describe Customer::Social::PostsController do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:post_object) { create(:post, user:) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    user.friends << friend
  end

  describe "GET #index" do
    it "returns a success response" do
      post_object
      get :index
      expect(response).to be_successful
      actual_response = JSON.parse(response.body, symbolize_names: true)
      expected_response = post_object.as_json(include: {
                                                user:     {only: %i[id nickname]},
                                                comments: {
                                                  include: {user: {only: %i[id nickname]}}
                                                }
                                              }).deep_symbolize_keys
      expect(actual_response).to eq([expected_response])
    end

    it "performs under 5 seconds under high data loads" do
      1000.times do
        Post.create!(content: "Test content", user: User.first)
      end
      expect { get :index }.to perform_under(5000).ms
    end
  end

  describe "POST #create" do
    it "creates a new post" do
      expect {
        post :create, params: {post: {content: "New post content"}}
      }.to change(Post, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT #update" do
    it "updates the post" do
      put :update, params: {id: post_object.id, post: {content: "Updated content"}}
      expect(response).to be_successful
      expect(post_object.reload.content).to eq("Updated content")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the post" do
      delete :destroy, params: {id: post_object.id}
      expect(response).to have_http_status(:no_content)
      expect(Post).not_to exist(post_object.id)
    end
  end

  describe "POST #like" do
    it "likes and unlikes the post" do
      post :like, params: {id: post_object.id}
      expect(response).to have_http_status(:created)
      expect(post_object.likes).to exist(user_id: user.id)

      post :like, params: {id: post_object.id}
      expect(response).to have_http_status(:ok)
      expect(post_object.likes).not_to exist(user_id: user.id)
    end
  end
end
