class RemoveDiseasesForeignKeyFromDiagnoses < ActiveRecord::Migration
  def change
    remove_foreign_key :diagnoses, column: :disease_code
  end
end
