# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.text :content, null: false, default: ""
      t.string :author, null: false, default: ""
      t.integer :rating, null: false, max: 5, min: 1
      t.integer :upvotes, null: false, default: 0
      t.integer :downvotes, null: false, default: 0

      t.timestamps
    end
  end
end
