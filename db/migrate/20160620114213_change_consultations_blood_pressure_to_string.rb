class ChangeConsultationsBloodPressureToString < ActiveRecord::Migration[5.1]
  def change
    change_column :consultations, :blood_pressure, :string, default: ""
  end
end
