class AddSerialToConsultations < ActiveRecord::Migration[5.2]
  def change
    add_column :consultations, :serial, :string
  end
end
