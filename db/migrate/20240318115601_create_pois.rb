class CreatePois < ActiveRecord::Migration[7.0]
  def change
    create_table :pois do |t|
      t.string :name, null: false
      t.text :description, null: false, default: ""
      t.string :location, null: false
      t.string :features, array: true, default: [], null: false
      t.integer :likes, default: 0, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end
  end
end
