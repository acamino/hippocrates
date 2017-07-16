class RemoveDiseasesForeignKeyFromDiagnoses < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :diagnoses, column: :disease_code
  end
end
