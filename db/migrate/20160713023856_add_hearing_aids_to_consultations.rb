class AddHearingAidsToConsultations < ActiveRecord::Migration
  def change
    add_column :consultations, :hearing_aids, :string, default: ''
  end
end
