# frozen_string_literal: true

module Customer
  module Social
    class UsersController < ApplicationController
      before_action :authorize_customer_controllers, :get_user
      # before_action :authenticate_user!

      # this is to return all users except current user, friends and requested friends
      # TODO: should almost certainly rename this
      def index
        friends_ids = @user.friends.pluck(:id)
        requested_friends_ids = @user.friend_requests.pluck(:friend_id)
        exclude_ids = friends_ids + requested_friends_ids + [@user.id]
        exclude_ids += User.where(user_type: User.user_types["admin"]).pluck(:id)
        exclude_ids += User.where(user_type: User.user_types["reporter"]).pluck(:id)
        users = User.where.not(id: exclude_ids).select(:id, :nickname)
        render json: users
      end

      def show
        render json: @user
      end

      SIMILARITY_THRESHOLD = 0.3
      MAXIMUM_NUMBER_OF_USER_SEARCH_RESULTS = 30
      def search_by_nickname
        nickname_query_string = params[:nickname]

        return render_bad_request if nickname_query_string.blank?

        similarity_query = User.select("users.*, similarity(nickname, #{ActiveRecord::Base.connection.quote(nickname_query_string)}) as similarity_score")
                               .where("similarity(nickname, ?) > #{SIMILARITY_THRESHOLD}", nickname_query_string)

        ilike_query = User.select("users.*, 0 as similarity_score")
                          .where("nickname ILIKE ?", "#{nickname_query_string}%")

        combined_query = User.from("(#{similarity_query.to_sql} UNION #{ilike_query.to_sql}) as users")
                             .select("DISTINCT ON (id) *")
                             .order("id, similarity_score DESC")
                             .limit(MAXIMUM_NUMBER_OF_USER_SEARCH_RESULTS)

        users_formatted = combined_query.map do |user|
          {
            id:       user.id,
            nickname: user.nickname
          }
        end

        render json: users_formatted
      end

      private

      def get_user
        @user = current_user

        render_internal_server_error if @user.nil?
      end
    end
  end
end
