class AddSpecialToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :special, :boolean, default: false, null: false
    add_index  :patients, :special
  end
end
