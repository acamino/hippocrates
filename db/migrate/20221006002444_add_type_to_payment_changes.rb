class AddTypeToPaymentChanges < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_changes, :type, :integer, null: false, default: 0
  end
end
