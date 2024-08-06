class AddNicknameDescriptionDeactivatedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nickname, :string, null: false, default: "DEFAULT"
    add_column :users, :description, :string, null: false, default: "DEFAULT"
    add_column :users, :deactivated, :boolean, default: false
  end
end
