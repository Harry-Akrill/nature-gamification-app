class CreateFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :favourites do |t|
      t.bigint :user_id, null: false
      t.bigint :poi_id, null: false

      t.timestamps
    end

    add_index :favourites, [:user_id, :poi_id], unique: true
  end
end
