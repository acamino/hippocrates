class RenamePriceChangesToPaymentChanges < ActiveRecord::Migration[6.1]
  def change
    rename_table :price_changes, :payment_changes
  end
end
