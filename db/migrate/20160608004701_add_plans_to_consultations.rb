class AddPlansToConsultations < ActiveRecord::Migration
  def change
    add_column :consultations, :diagnostic_plan, :string
    add_column :consultations, :treatment_plan, :string
    add_column :consultations, :educational_plan, :string
  end
end
