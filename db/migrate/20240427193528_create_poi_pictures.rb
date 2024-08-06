class CreatePoiPictures < ActiveRecord::Migration[7.0]
  def change
    create_table :poi_pictures do |t|
      t.bigint :user_id, null: false
      t.bigint :poi_id, null: false

      t.timestamps
    end
  end
end
