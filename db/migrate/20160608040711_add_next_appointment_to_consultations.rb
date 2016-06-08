class AddNextAppointmentToConsultations < ActiveRecord::Migration
  def change
    add_column :consultations, :next_appointment, :datetime
  end
end
