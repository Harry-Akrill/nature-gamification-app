class AddReportedToPoiComments < ActiveRecord::Migration[6.0]
  def change
    add_column :poi_comments, :reported, :boolean, default: false
  end
end
