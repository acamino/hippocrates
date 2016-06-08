class AddMiscellaneousToConsultations < ActiveRecord::Migration
  def change
    add_column :consultations, :miscellaneous, :string
  end
end
