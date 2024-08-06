# frozen_string_literal: true

require "rails_helper"
require "rspec-benchmark"
require "spec_helper"

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

RSpec.describe Admin::PoiCommentsController do
  let(:user) { create(:user, user_type: "customer") }
  let(:admin) { create(:user, user_type: "admin") }
  let(:poi) { create(:poi) }
  let(:comment) { create(:poi_comment, user:, poi:, reported: true) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET #all_comments" do
    context "when an admin" do
      let(:current_user) { admin }

      before do
        get :all_comments
      end

      it "returns a success response" do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe "DELETE #delete_comment" do
    context "when an admin" do
      let(:current_user) { admin }

      it "deletes the comment" do
        delete :delete_comment, params: {id: comment.id}
        expect(response).to have_http_status(:success)
        expect(PoiComment).not_to exist(comment.id)
      end

      it "returns not_found if comment not found" do
        delete :delete_comment, params: {id: "nonexistent_id"}
        expect(response).to have_http_status(:not_found)
      end

      it "returns unprocessable_entity if deletion fails" do
        allow_any_instance_of(PoiComment).to receive(:destroy).and_return(false)
        delete :delete_comment, params: {id: comment.id}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #toggle_report_status" do
    context "when an admin" do
      let(:current_user) { admin }

      it "toggles the report status of the comment" do
        patch :toggle_report_status, params: {id: comment.id}
        expect(comment.reload.reported).to be_falsey
      end
    end
  end

  describe "comment_params" do
    context "when an admin" do
      let(:current_user) { admin }

      let(:params) do
        {
          poi_comment: {
            id:      1,
            user_id: 2,
            poi_id:  3,
            text:    "Sample text",
            rating:  4
          }
        }
      end

      it "permits specific parameters" do
        controller.params = ActionController::Parameters.new(params)
        expect(controller.send(:comment_params).to_h).to eq({
                                                              "id"      => 1,
                                                              "user_id" => 2,
                                                              "poi_id"  => 3,
                                                              "text"    => "Sample text",
                                                              "rating"  => 4
                                                            })
      end

      it "rejects additional parameters" do
        controller.params = ActionController::Parameters.new(params.merge(extra_param: "value"))
        expect(controller.send(:comment_params).to_h).to eq({
                                                              "id"      => 1,
                                                              "user_id" => 2,
                                                              "poi_id"  => 3,
                                                              "text"    => "Sample text",
                                                              "rating"  => 4
                                                            })
      end
    end
  end
end
