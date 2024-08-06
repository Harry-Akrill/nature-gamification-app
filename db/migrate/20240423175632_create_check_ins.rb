class CreateCheckIns < ActiveRecord::Migration[7.0]
  def change
    create_table :check_ins do |t|
      t.bigint :user_id, null: false
      t.bigint :poi_id, null: false

      t.timestamps
    end

    add_index :check_ins, [:user_id, :poi_id], unique: true
  end
end
