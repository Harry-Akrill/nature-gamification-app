# frozen_string_literal: true

# == Schema Information
#
# Table name: poi_pictures
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poi_id     :bigint           not null
#  user_id    :bigint           not null
#
require "rails_helper"

RSpec.describe PoiPicture do
  let(:user) { create(:user, user_type: "customer") }
  let(:poi) { create(:poi) }
  let(:valid_picture) {
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/image0001.jpeg"), "image/jpeg")
  }
  let(:poi_picture) { create(:poi_picture, poi_id: poi.id, user_id: user.id, picture: valid_picture) }

  describe "#picture_id" do
    it "returns the blob id of the attached picture" do
      expect(poi_picture.picture_id).to eq(poi_picture.picture.blob.id)
    end

    it "returns nil if no picture is attached" do
      poi_picture = described_class.new
      expect(poi_picture.picture_id).to be_nil
    end
  end
end
