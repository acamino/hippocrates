class RenamePriceFieldsToPaymentFieldsOnPaymentChanges < ActiveRecord::Migration[6.1]
  def change
    rename_column :payment_changes, :previous_price, :previous_payment
    rename_column :payment_changes, :updated_price,  :updated_payment
  end
end
