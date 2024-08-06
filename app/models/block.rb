# frozen_string_literal: true

# == Schema Information
#
# Table name: blocks
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  blocked_user_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_blocks_on_blocked_user_id  (blocked_user_id)
#  index_blocks_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (blocked_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class Block < ApplicationRecord
  belongs_to :user
  belongs_to :blocked_user, class_name: "User"

  def create
    block = Block.new(block_params)

    if block.save
      render json: block, status: :created
    else
      render json: block.errors, status: :unprocessable_entity
    end
  end

  private

  def block_params
    params.permit(:user_id, :blocked_user_id)
  end
end
