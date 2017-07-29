class UpdateIndexesInPatients < ActiveRecord::Migration[5.1]
  def change
    remove_index :patients, :first_name
    remove_index :patients, :last_name
    add_index :patients, [:first_name, :last_name], using: :gin
  end
end
