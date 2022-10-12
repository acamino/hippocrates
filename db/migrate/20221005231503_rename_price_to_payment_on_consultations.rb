class RenamePriceToPaymentOnConsultations < ActiveRecord::Migration[6.1]
  def change
    rename_column :consultations, :price, :payment
  end
end
