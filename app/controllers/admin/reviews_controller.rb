# frozen_string_literal: true

module Admin
  class ReviewsController < ApplicationController
    before_action :authorize_admin_controllers

    def all_reviews
      render json: {users: Review.order(created_at: :desc).select(:id, :content, :author, :upvotes, :downvotes,
                                                                  :rating)}
    end

    def delete_review
      read_id_param
      review = Review.find(@id)

      return render_bad_request if review.nil?

      review.destroy
      render json: {message: "Deleted review successfully"}
    end

    def read_id_param
      @id = params[:id]
      render_bad_request if @id.nil?
    end
  end
end
