# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

RSpec.describe QuestionsController do
  let(:user) { create(:user, user_type: "customer") }
  let(:question) { create(:question) }
  let(:question2) { create(:question) }

  # before do
  #    allow(controller).to receive(:current_user).and_return(current_user)
  # end

  describe "#all_questions" do
    it "returns a list of all the questions" do
      get :all_questions
      expect {
        get :all_questions
      }.to perform_under(50).ms
      expect(response).to have_http_status :ok
      json_response = response.parsed_body

      expect(json_response).to have_key("questions")
      expect(json_response["questions"]).to be_an(Array)

      expect(json_response).to have_key("awaiting_approval")
    end

    it "returns appropriate session data" do
      session[:questions_upvoted] = [1, 2]

      get :all_questions
      expect(response).to have_http_status :ok
      json_response = response.parsed_body

      expect(json_response).to have_key("upvoted")
      expect(json_response["upvoted"]).to be_an(Array)
      expect(json_response["upvoted"]).to eq([1, 2])
    end
  end

  describe "#submit_question" do
    context "with a valid question" do
      let(:valid_question) { "How does this app work?" }

      it "creates a new question and returns a success message" do
        post :submit_question, params: {question: valid_question}
        expect {
          post :submit_question, params: {question: valid_question}
        }.to perform_under(50).ms
        expect(response).to have_http_status :ok
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Question created successfully")
      end

      it "adds the new question ID to session[:questions_submitted]" do
        post :submit_question, params: {question: valid_question}

        expect(session[:questions_submitted]).to include(Question.last.id)
      end
    end

    context "with an invalid question" do
      let(:invalid_question) { "" }

      it "renders a bad request response" do
        post :submit_question, params: {question: invalid_question}

        expect(response).to have_http_status(:bad_request)
      end

      it "does not create a new question" do
        expect {
          post :submit_question, params: {question: invalid_question}
        }.not_to change(Question, :count)
      end

      it "does not add any question ID to session[:questions_submitted]" do
        post :submit_question, params: {question: invalid_question}

        expect(session[:questions_submitted]).to be_empty
      end
    end
  end

  describe "#upvote_question" do
    before do
      @question = create(:question)
      session[:questions_upvoted] = []
      session[:questions_downvoted] = [@question.id]
    end

    # rubocop:disable RSpec/InstanceVariable
    context "when question is upvoted successfully" do
      it "upvotes a question and returns a success message" do
        post :upvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Question upvoted successfully")
      end

      it "adds the question ID to session[:questions_upvoted]" do
        post :upvote_question, params: {id: @question.id}

        expect(session[:questions_upvoted].map(&:to_i)).to include(@question.id)
      end

      it "updates the upvotes count in the database" do
        expect {
          post :upvote_question, params: {id: @question.id}
          @question.reload
        }.to change { @question.upvotes }.by(1)
      end

      it "decreases the downvotes count and removes the question ID from session[:questions_downvoted]" do
        session[:questions_downvoted] = [@question.id]
        post :upvote_question, params: {id: @question.id}
        @question.reload

        expect(@question.downvotes).to eq(0)
        expect(session[:questions_downvoted]).not_to include(@question.id.to_s)
      end
    end
    # rubocop:enable RSpec/InstanceVariable

    # rubocop:disable RSpec/InstanceVariable
    context "when the question has already been upvoted" do
      before { session[:questions_upvoted] = [@question.id] }

      it "renders a bad request response with a message" do
        post :upvote_question, params: {id: @question.id}
        post :upvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Already upvoted")
      end

      it "does not add the question ID to session[:questions_upvoted]" do
        expect { post :upvote_question, params: {id: @question.id} }.to(change {
                                                                          session[:questions_upvoted].uniq
                                                                        })
      end

      it "does not update the upvotes count in the database" do
        post :upvote_question, params: {id: @question.id}
        @question.reload
        expect {
          post :upvote_question, params: {id: @question.id}
          @question.reload
        }.not_to(change { @question.upvotes })
      end
    end
    # rubocop:enable RSpec/InstanceVariable
  end

  # rubocop:disable RSpec/InstanceVariable
  describe "#downvote_question" do
    before do
      @question = create(:question)
      session[:questions_downvoted] = []
    end

    context "when question is downvoted successfully" do
      it "downvotes a question and returns a success message" do
        post :downvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Question downvoted successfully")
      end

      it "adds the question ID to session[:questions_downvoted]" do
        post :downvote_question, params: {id: @question.id}

        expect(session[:questions_downvoted].map(&:to_i)).to include(@question.id)
      end

      it "updates the downvotes count in the database" do
        expect {
          post :downvote_question, params: {id: @question.id}
          @question.reload
        }.to change { @question.downvotes }.by(1)
      end
    end

    context "when the question has already been downvoted" do
      before { session[:questions_downvoted] = [@question.id] }

      it "renders a bad request response with a message" do
        post :downvote_question, params: {id: @question.id}
        post :downvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Already downvoted")
      end

      it "does not add the question ID to session[:questions_downvoted]" do
        expect { post :downvote_question, params: {id: @question.id} }.to(change {
                                                                            session[:questions_downvoted].uniq
                                                                          })
      end

      it "does not update the downvotes count in the database" do
        post :downvote_question, params: {id: @question.id}
        @question.reload
        expect {
          post :downvote_question, params: {id: @question.id}
          @question.reload
        }.not_to(change { @question.downvotes })
      end
    end
  end
  # rubocop:enable RSpec/InstanceVariable

  describe "#cancel_upvote_question" do
    # rubocop:disable RSpec/InstanceVariable
    before do
      @question = create(:question)
      session[:questions_upvoted] = [@question.id.to_s]
    end
    # rubocop:enable RSpec/InstanceVariable

    # rubocop:disable RSpec/InstanceVariable
    context "when cancelling an upvote successfully" do
      it "cancels an upvote and returns a success message" do
        post :cancel_upvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Question upvote cancelled successfully")
      end

      it "removes the question ID from session[:questions_upvoted]" do
        post :cancel_upvote_question, params: {id: @question.id}

        expect(session[:questions_upvoted]).to be_empty
      end

      it "updates the upvotes count in the database" do
        expect {
          post :cancel_upvote_question, params: {id: @question.id}
          @question.reload
        }.to change { @question.upvotes }.by(-1)
      end
    end
    # rubocop:enable RSpec/InstanceVariable

    context "when attempting to cancel an upvote for a question that has not been upvoted" do
      before { session[:questions_upvoted] = [] }

      # rubocop:disable RSpec/InstanceVariable
      it "renders a bad request response with a message" do
        post :cancel_upvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Nothing to cancel, question hasn't been upvoted")
      end
      # rubocop:enable RSpec/InstanceVariable

      # rubocop:disable RSpec/InstanceVariable
      it "does not change the session[:questions_upvoted]" do
        expect {
          post :cancel_upvote_question, params: {id: @question.id}
        }.not_to(change { session[:questions_upvoted] })
      end
      # rubocop:enable RSpec/InstanceVariable

      # rubocop:disable RSpec/InstanceVariable
      it "does not update the upvotes count in the database" do
        expect {
          post :cancel_upvote_question, params: {id: @question.id}
          @question.reload
        }.not_to(change { @question.upvotes })
      end
      # rubocop:enable RSpec/InstanceVariable
    end
  end

  describe "#cancel_downvote_question" do
    # rubocop:disable RSpec/InstanceVariable
    before do
      @question = create(:question)
      session[:questions_downvoted] = [@question.id.to_s]
    end
    # rubocop:enable RSpec/InstanceVariable

    # rubocop:disable RSpec/InstanceVariable
    context "when cancelling an downvote successfully" do
      it "cancels an downvote and returns a success message" do
        post :cancel_downvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Question downvote cancelled successfully")
      end

      it "removes the question ID from session[:questions_downvoted]" do
        post :cancel_downvote_question, params: {id: @question.id}

        expect(session[:questions_downvoted]).to be_empty
      end

      it "updates the downvotes count in the database" do
        expect {
          post :cancel_downvote_question, params: {id: @question.id}
          @question.reload
        }.to change { @question.downvotes }.by(-1)
      end
    end
    # rubocop:enable RSpec/InstanceVariable

    context "when attempting to cancel an downvote for a question that has not been downvoted" do
      before { session[:questions_downvoted] = [] }

      # rubocop:disable RSpec/InstanceVariable
      it "renders a bad request response with a message" do
        post :cancel_downvote_question, params: {id: @question.id}

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body

        expect(json_response).to have_key("message")
        expect(json_response["message"]).to eq("Nothing to cancel, question hasn't been downvoted")
      end
      # rubocop:enable RSpec/InstanceVariable

      # rubocop:disable RSpec/InstanceVariable
      it "does not change the session[:questions_downvoted]" do
        expect {
          post :cancel_downvote_question, params: {id: @question.id}
        }.not_to(change { session[:questions_downvoted] })
      end
      # rubocop:enable RSpec/InstanceVariable

      # rubocop:disable RSpec/InstanceVariable
      it "does not update the downvotes count in the database" do
        expect {
          post :cancel_downvote_question, params: {id: @question.id}
          @question.reload
        }.not_to(change { @question.downvotes })
      end
      # rubocop:enable RSpec/InstanceVariable
    end
  end
end
