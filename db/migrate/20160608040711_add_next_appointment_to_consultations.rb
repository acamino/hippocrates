class AddNextAppointmentToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :next_appointment, :datetime
  end
end
