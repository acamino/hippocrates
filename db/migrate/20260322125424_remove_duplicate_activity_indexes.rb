class RemoveDuplicateActivityIndexes < ActiveRecord::Migration[8.1]
  def change
    remove_index :activities, [:trackable_id, :trackable_type]
    remove_index :activities, [:owner_id, :owner_type]
    remove_index :activities, [:recipient_id, :recipient_type]
  end
end
