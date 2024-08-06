class CreatePoiComments < ActiveRecord::Migration[7.0]
  def change
    create_table :poi_comments do |t|
      t.references :poi, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :text
      t.integer :rating

      t.timestamps
    end
  end
end
