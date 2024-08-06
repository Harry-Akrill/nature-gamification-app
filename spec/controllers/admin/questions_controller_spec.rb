# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::QuestionsController do
  let(:admin) { create(:user, user_type: "admin") }
  let(:user) { create(:user, user_type: "customer") }
  let(:question) { create(:question) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET #index" do
    context "when the user is an admin" do
      let(:current_user) { admin }

      before do
        get :all_questions
      end

      it "returns a 200 response" do
        expect(response).to have_http_status :ok
      end
    end

    context "when the user is not an admin" do
      let(:current_user) { user }

      before do
        get :all_questions
      end

      it "returns a 401 response" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "POST #answer_edit_create_question" do
    let(:question_params) { {id: question.id, answer: "this is a test answer", question: "this is a test question"} }

    context "when the user is an admin" do
      let(:current_user) { admin }

      before do
        post :answer_edit_create_question, params: question_params
      end

      it "updates the question and answer and returns a 200 response" do
        expect(response).to have_http_status :ok
        expect(response.parsed_body["message"]).to eq "Question answered/edited successfully"
        question.reload
        expect(question.question).to eq "this is a test question"
        expect(question.answer).to eq "this is a test answer"
      end
    end

    context "when the user is not an admin" do
      let(:current_user) { user }

      before do
        put :answer_edit_create_question, params: question_params
      end

      it "does not update the question and answer and returns a 401 response" do
        expect(response).to have_http_status :unauthorized
        question.reload
        expect(question.question).not_to eq "this is a test question"
        expect(question.answer).not_to eq "this is a test answer"
      end
    end
  end

  describe "DELETE #delete_question" do
    let(:question_params) { {id: question.id} }

    context "when the user is an admin" do
      let(:current_user) { admin }

      before do
        delete :delete_question, params: question_params
      end

      it "deletes the question and returns a 200 response" do
        expect(response).to have_http_status :ok
        expect(response.parsed_body["message"]).to eq "Question deleted successfully"
        expect(Question.find_by(id: question.id)).to be_nil
      end
    end

    context "when the user is not an admin" do
      let(:current_user) { user }

      before do
        delete :delete_question, params: question_params
      end

      it "does not delete the question and returns a 401 response" do
        expect(response).to have_http_status :unauthorized
        expect(Question.find_by(id: question.id)).not_to be_nil
      end
    end
  end
end
