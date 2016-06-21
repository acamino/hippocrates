class RenamePersonalHistoryToMedicalHistory < ActiveRecord::Migration
  def change
    rename_column :anamneses, :personal_history, :medical_history
  end
end
