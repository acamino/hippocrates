class AddUniqueConstraintsToPatients < ActiveRecord::Migration
  def change
    remove_index :patients, column: :identity_card_number
    add_index :patients, :identity_card_number, unique: true
    add_index :patients, :medical_history,       unique: true
  end
end
