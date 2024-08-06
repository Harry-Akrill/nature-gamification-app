class CreateLandingPageVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :landing_page_visits do |t|
      t.string :session_id, null: false
      t.string :ip_address, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.string :country, null: false
      t.integer :time_spent_seconds, null: false, default: 0
      t.text :path_to_registration, null: false, default: ""
      t.string :email_of_registered_user

      t.timestamps
    end
  end
end
