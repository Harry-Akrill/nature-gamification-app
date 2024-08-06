class AddLatitudeLongitudeCountryToAppVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :app_visits, :latitude, :decimal, null: false, default: 0
    add_column :app_visits, :longitude, :decimal, null: false, default: 0
    add_column :app_visits, :country, :string, null: false, default: "DEFAULT"
    add_column :app_visits, :email, :string, null: false, default: "DEFAULT"
    add_column :app_visits, :viewed_pois, :bigint, array: true, default: [], null: false
  end
end
