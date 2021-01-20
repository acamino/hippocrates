class AddHearingAidsToAnamneses < ActiveRecord::Migration[5.2]
  def change
    add_column :anamneses, :hearing_aids, :boolean, null: false, default: false
  end
end
