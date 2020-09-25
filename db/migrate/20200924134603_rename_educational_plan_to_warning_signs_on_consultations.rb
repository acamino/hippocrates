class RenameEducationalPlanToWarningSignsOnConsultations < ActiveRecord::Migration[5.2]
  def change
    rename_column :consultations, :educational_plan, :warning_signs
  end
end
