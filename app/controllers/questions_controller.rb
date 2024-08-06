# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :assign_defaults_to_session

  def all_questions
    render json: {
      questions: Question.where.not(answer: nil).order(created_at: :desc).select(:id, :question, :answer,
                                                                                 :upvotes, :downvotes),
                    awaiting_approval:, upvoted: session[:questions_upvoted], downvoted: session[:questions_downvoted],
                    total_number_of_questions: Question.count
    }
  end

  def submit_question
    question = params[:question]
    return render_bad_request, status: :bad_request if question.blank?

    question_object = Question.new
    question_object.question = question
    return render_bad_request, status: :bad_request unless question_object.valid?

    question_object.save
    session[:questions_submitted].append(question_object.id)
    render json: {message: "Question created successfully"}
  end

  def upvote_question
    read_id_param
    @question = find_question
    return render json: {message: "Already upvoted"}, status: :bad_request if session[:questions_upvoted].include?(@id)

    update_session_and_question_after_upvote
    return render_bad_request, status: :bad_request unless @question.valid?

    @question.save
    render json: {message: "Question upvoted successfully"}
  end

  def downvote_question
    read_id_param
    @question = find_question
    if session[:questions_downvoted].include?(@id)
      return render json:   {message: "Already downvoted"},
                    status: :bad_request
    end
    update_session_and_question_after_downvote
    return render_bad_request, status: :bad_request unless @question.valid?

    @question.save
    render json: {message: "Question downvoted successfully"}
  end

  def cancel_upvote_question
    read_id_param
    question = find_question
    unless session[:questions_upvoted].include?(@id)
      return render json: {message: "Nothing to cancel, question hasn't been upvoted"}, status: :bad_request
    end

    session[:questions_upvoted].delete(@id)
    question.upvotes -= 1
    return render_bad_request, status: :bad_request unless question.valid?

    question.save
    render json: {message: "Question upvote cancelled successfully"}
  end

  def cancel_downvote_question
    read_id_param
    question = find_question
    unless session[:questions_downvoted].include?(@id)
      return render json: {message: "Nothing to cancel, question hasn't been downvoted"}, status: :bad_request
    end

    session[:questions_downvoted].delete(@id)
    question.downvotes -= 1
    return render_bad_request, status: :bad_request unless question.valid?

    question.save
    render json: {message: "Question downvote cancelled successfully"}
  end

  private

  def assign_defaults_to_session
    session[:questions_upvoted] = [] if session[:questions_upvoted].nil?
    session[:questions_downvoted] = [] if session[:questions_downvoted].nil?
    session[:questions_submitted] = [] if session[:questions_submitted].nil?
  end

  def find_question
    question = Question.find(@id)
    return render_bad_request, status: :bad_request if question.nil?

    question
  end

  def read_id_param
    @id = params[:id]
    render_bad_request if @id.nil?
  end

  def update_session_and_question_after_upvote
    session[:questions_upvoted].append(@id)
    if session[:questions_downvoted].include?(@id)
      @question.downvotes -= 1
      session[:questions_downvoted].delete(@id)
    end
    @question.upvotes += 1
  end

  def update_session_and_question_after_downvote
    session[:questions_downvoted].append(@id)
    if session[:questions_upvoted].include?(@id)
      @question.upvotes -= 1
      session[:questions_upvoted].delete(@id)
    end
    @question.downvotes += 1
  end

  def awaiting_approval
    Question.where(answer: nil).select(:id, :question).select do |question|
      session[:questions_submitted].include?(question.id)
    end
  end
end
