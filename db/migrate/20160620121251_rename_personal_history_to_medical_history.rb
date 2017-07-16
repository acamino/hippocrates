class RenamePersonalHistoryToMedicalHistory < ActiveRecord::Migration[5.1]
  def change
    rename_column :anamneses, :personal_history, :medical_history
  end
end
