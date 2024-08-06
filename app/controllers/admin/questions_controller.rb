# frozen_string_literal: true

module Admin
  class QuestionsController < ApplicationController
    before_action :authorize_admin_controllers

    def all_questions
      render json: {questions: Question.order(created_at: :desc).select(:id, :question, :answer, :upvotes,
                                                                        :downvotes)}
    end

    def answer_edit_create_question
      read_id_param
      @question_object = Question.find(@id)
      return render_bad_request if @question_object.nil?

      update_question_and_answer
      return render_internal_server_error unless @question_object.valid?

      @question_object.save
      render json: {message: "Question answered/edited successfully"}
    end

    def delete_question
      read_id_param
      question_object = Question.find(@id)
      return render_bad_request if question_object.nil?

      question_object.destroy
      render json: {message: "Question deleted successfully"}
    end

    private

    def update_question_and_answer
      question = params[:question]
      answer = params[:answer]
      question = @question_object.question if question.blank?
      answer = nil if !answer.nil? && answer.empty?
      @question_object.question = question
      @question_object.answer = answer
    end

    def read_id_param
      @id = params[:id]
      render_bad_request if @id.nil?
    end
  end
end
