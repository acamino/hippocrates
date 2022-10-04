class AddPricedToConsultations < ActiveRecord::Migration[6.1]
  def change
    add_column :consultations, :priced, :boolean, null: false, default: false
  end
end
