class AddMissingForeignKeyIndexes < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :anamneses,     :patient_id,      algorithm: :concurrently
    add_index :consultations, :patient_id,      algorithm: :concurrently
    add_index :diagnoses,     :consultation_id,  algorithm: :concurrently
    add_index :prescriptions, :consultation_id,  algorithm: :concurrently
  end
end
