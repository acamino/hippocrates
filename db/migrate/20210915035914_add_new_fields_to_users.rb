class AddNewFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin,              :boolean, null: false, default: false
    add_column :users, :super_admin,        :boolean, null: false, default: false
    add_column :users, :active,             :boolean, null: false, default: true
    add_column :users, :first_name,         :string
    add_column :users, :last_name,          :string
    add_column :users, :pretty_name,        :string
    add_column :users, :phone_number,       :string
    add_column :users, :registration_acess, :string
    add_column :users, :speciality,         :string
    add_column :users, :serial,             :integer, null: false, default: 0

    add_index :users, :registration_acess, unique: true
  end
end
