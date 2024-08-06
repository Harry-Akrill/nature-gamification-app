# frozen_string_literal: true

class CreateMailingList < ActiveRecord::Migration[7.0]
  def change
    create_table :mailing_list do |t|
      t.string :email, null: false, unique: true

      t.timestamps
    end
  end
end
