class AddDiscardedAtToConsultations < ActiveRecord::Migration[5.2]
  def change
    add_column :consultations, :discarded_at, :datetime
    add_index :consultations, :discarded_at
  end
end
