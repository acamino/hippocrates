class AddHearingAidsToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :hearing_aids, :string, default: ''
  end
end
