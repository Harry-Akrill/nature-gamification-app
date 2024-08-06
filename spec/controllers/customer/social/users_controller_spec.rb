# frozen_string_literal: true

RSpec.describe Customer::Social::UsersController do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:requested_friend) { create(:user) }
  let(:admin) { create(:user, user_type: User.user_types["admin"]) }
  let(:reporter) { create(:user, user_type: User.user_types["reporter"]) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    user.friends << friend
    user.friend_requests.create(friend: requested_friend)
  end

  describe "GET #index" do
    it "returns users excluding current user, friends, requested friends, admins, and reporters" do
      other_user = create(:user)
      get :index
      expect(response).to be_successful
      parsed_response = response.parsed_body
      expect(parsed_response).to include(hash_including("id" => other_user.id, "nickname" => other_user.nickname))
      expect(parsed_response).not_to include(hash_including("id" => user.id))
      expect(parsed_response).not_to include(hash_including("id" => friend.id))
      expect(parsed_response).not_to include(hash_including("id" => requested_friend.id))
      expect(parsed_response).not_to include(hash_including("id" => admin.id))
      expect(parsed_response).not_to include(hash_including("id" => reporter.id))
    end

    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "returns a JSON response" do
      get :index
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it "does not include the current user in the response" do
      get :index
      parsed_response = response.parsed_body
      expect(parsed_response).not_to include(hash_including("id" => user.id))
    end
  end

  describe "GET #search_by_nickname" do
    let(:nickname_query_string) { "test" }

    it "returns a success response" do
      get :search_by_nickname, params: {nickname: nickname_query_string}
      expect(response).to be_successful
    end

    it "returns users with similar nicknames" do
      similar_user = create(:user, nickname: "#{nickname_query_string}123")
      get :search_by_nickname, params: {nickname: nickname_query_string}
      json_response = response.parsed_body
      expect(json_response.pluck("id")).to include(similar_user.id)
    end
  end
end
