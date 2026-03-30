class AddCanDeletePatientsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :can_delete_patients, :boolean, default: false, null: false
  end
end
