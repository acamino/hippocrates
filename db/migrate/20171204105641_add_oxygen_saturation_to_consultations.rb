class AddOxygenSaturationToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :oxygen_saturation, :integer, default: 0
  end
end
