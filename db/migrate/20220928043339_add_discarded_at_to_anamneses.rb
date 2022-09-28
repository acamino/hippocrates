class AddDiscardedAtToAnamneses < ActiveRecord::Migration[5.2]
  def change
    add_column :anamneses, :discarded_at, :datetime
    add_index :anamneses, :discarded_at
  end
end
