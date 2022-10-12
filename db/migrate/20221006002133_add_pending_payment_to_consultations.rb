class AddPendingPaymentToConsultations < ActiveRecord::Migration[6.1]
  def change
    add_column :consultations, :pending_payment, :decimal, null: false, default: 0.0
  end
end
