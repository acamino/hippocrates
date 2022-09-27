class AddPriceToConsultations < ActiveRecord::Migration[5.2]
  def change
    add_column :consultations, :price, :decimal, null: false, default: 0.0
  end
end
