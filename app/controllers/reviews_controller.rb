# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :assign_defaults_to_session
  before_action :read_review_params, only: :submit_review
  before_action :read_id_param, only: %i[upvote_review downvote_review cancel_upvote_review cancel_downvote_review]

  def all_reviews
    reviews = Review.order(created_at: :desc).select(:id, :content, :author, :upvotes, :downvotes, :rating)
    render json: {reviews:,
                   upvoted: session[:reviews_upvoted], downvoted: session[:reviews_downvoted]}
  end

  def submit_review
    read_review_params
    review = Review.new(content: @content, author: @author, rating: @rating)
    return render_bad_request unless review.valid?

    review.save
    render json: {message: "Review created successfully"}
  end

  def upvote_review
    @review = find_review

    return render json: {message: "Already upvoted"}, status: :bad_request if session[:reviews_upvoted].include?(@id)

    update_session_and_review_after_upvote
    return render_bad_request unless @review.valid?

    @review.save
    render json: {message: "Review upvoted successfully"}
  end

  def downvote_review
    @review = find_review
    if session[:reviews_downvoted].include?(@id)
      return render json:   {message: "Already downvoted"},
                    status: :bad_request
    end
    update_session_and_review_after_downvote
    return render_bad_request unless @review.valid?

    @review.save
    render json: {message: "Review downvoted successfully"}
  end

  def cancel_upvote_review
    review = find_review

    unless session[:reviews_upvoted].include?(@id)
      return render json: {message: "Nothing to cancel, review hasn't been upvoted"}, status: :bad_request
    end

    session[:reviews_upvoted].delete(@id)
    review.upvotes -= 1
    return render_bad_request unless review.valid?

    review.save
    render json: {message: "Review upvote cancelled successfully"}
  end

  def cancel_downvote_review
    review = find_review

    unless session[:reviews_downvoted].include?(@id)
      return render json: {message: "Nothing to cancel, review hasn't been downvoted"}, status: :bad_request
    end

    session[:reviews_downvoted].delete(@id)
    review.downvotes -= 1
    return render_bad_request unless review.valid?

    review.save
    render json: {message: "Review downvote cancelled successfully"}
  end

  private

  def assign_defaults_to_session
    session[:reviews_upvoted] = [] if session[:reviews_upvoted].nil?
    session[:reviews_downvoted] = [] if session[:reviews_downvoted].nil?
  end

  def find_review
    review = Review.find(@id)
    return render_bad_request if review.nil?

    review
  end

  def read_review_params
    @content = params[:content]
    @author = params[:author].nil? ? "anonymous" : params[:author]
    @rating = params[:rating].to_i

    if @content.blank? || @rating.nil? || !@rating.between?(
      1, 5
    )
      render json:   {message: "Bad request"},
             status: :bad_request
    end
  end

  def read_id_param
    @id = params[:id]
    render_bad_request if @id.nil?
  end

  def update_session_and_review_after_upvote
    session[:reviews_upvoted].append(@id)
    if session[:reviews_downvoted].include?(@id)
      @review.downvotes -= 1
      session[:reviews_downvoted].delete(@id)
    end
    @review.upvotes += 1
  end

  def update_session_and_review_after_downvote
    session[:reviews_downvoted].append(@id)
    if session[:reviews_upvoted].include?(@id)
      @review.upvotes -= 1
      session[:reviews_upvoted].delete(@id)
    end
    @review.downvotes += 1
  end
end
