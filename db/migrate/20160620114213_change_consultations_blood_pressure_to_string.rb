class ChangeConsultationsBloodPressureToString < ActiveRecord::Migration
  def change
    change_column :consultations, :blood_pressure, :string, default: ""
  end
end
