class AddDiscardedAtToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :discarded_at, :datetime
    add_index :patients, :discarded_at
  end
end
