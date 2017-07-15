class AddMiscellaneousToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :miscellaneous, :string
  end
end
