class SendPaymentNotificationJob < ApplicationJob
  queue_as :default

  def perform(payment_change_id)
    payment_change = PaymentChange.find(payment_change_id)
    subject, message = Notifications::Messages::Builder.new(payment_change).call
    Notifications::Sender.new(subject, message).call
  end
end
