class AddDoctorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :doctor, :boolean, null: false, default: true
  end
end
