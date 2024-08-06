# frozen_string_literal: true

class FriendRequestMailer < ApplicationMailer
  def friend_request(friend_request)
    @friend_request = friend_request
    mail(to: @friend_request.friend.email, subject: "New Friend Request")
  end
end
