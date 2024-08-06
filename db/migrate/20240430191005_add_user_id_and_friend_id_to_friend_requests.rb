class AddUserIdAndFriendIdToFriendRequests < ActiveRecord::Migration[7.0]
    def change
      add_reference :friend_requests, :user, foreign_key: true
      add_reference :friend_requests, :friend, foreign_key: { to_table: :users }
    end
  end