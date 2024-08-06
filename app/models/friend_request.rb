# frozen_string_literal: true

# == Schema Information
#
# Table name: friend_requests
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_friend_requests_on_friend_id  (friend_id)
#  index_friend_requests_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (friend_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  validate :not_friends
  validate :not_pending

  def accept
    user.friends << friend
    destroy
  end

  private

  def not_friends
    errors.add(:friend, "already added") if user.friends.include?(friend)
  end

  def not_pending
    errors.add(:friend, "already requested") if friend.pending_friends.include?(user)
  end
end
