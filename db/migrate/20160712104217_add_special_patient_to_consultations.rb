class AddSpecialPatientToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :special_patient, :boolean, default: false, null: false
    add_index  :consultations, :special_patient
  end
end
