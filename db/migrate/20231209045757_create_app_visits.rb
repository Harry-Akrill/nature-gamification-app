class CreateAppVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :app_visits do |t|
      t.string :session_id, null: false
      t.string :ip_address, null: false
      t.integer :time_spent_seconds, null: false, default: 0

      t.timestamps
    end
  end
end
