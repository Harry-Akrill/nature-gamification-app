# frozen_string_literal: true

module Admin
  class MailingListController < ApplicationController
    before_action :authorize_admin_controllers

    def all_emails
      render json: {emails: MailingList.order(created_at: :desc).select(:email)}
    end
  end
end
