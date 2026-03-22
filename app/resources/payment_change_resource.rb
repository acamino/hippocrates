# frozen_string_literal: true

class PaymentChangeResource
  include Alba::Resource

  attributes :date, :reason, :previousPayment, :updatedPayment, :userName

  def date(payment_change)
    payment_change.created_at.strftime('%b %d, %Y %I:%M %p')
  end

  def previousPayment(payment_change)
    format('%.2f', payment_change.previous_payment)
  end

  def updatedPayment(payment_change)
    format('%.2f', payment_change.updated_payment)
  end

  def userName(payment_change)
    payment_change.user.pretty_name.upcase
  end
end
