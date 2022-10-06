class PaymentChangeSerializer < ActiveModel::Serializer
  attributes :date,
             :reason

  attribute :previous_payment, key: :previousPayment
  attribute :updated_payment,  key: :updatedPayment
  attribute :user_name,        key: :userName

  delegate :user, to: :object

  def previous_payment
    format('%.2f', object.previous_payment)
  end

  def updated_payment
    format('%.2f', object.updated_payment)
  end

  def user_name
    user.pretty_name.upcase
  end

  def date
    object.created_at.strftime('%b %d, %Y %I:%M %p')
  end
end
