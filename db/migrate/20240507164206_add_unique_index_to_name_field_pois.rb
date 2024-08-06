class AddUniqueIndexToNameFieldPois < ActiveRecord::Migration[7.0]
  def change
    add_index :pois, :name, unique: true
  end
end
