class PaymentChange < ApplicationRecord
  self.inheritance_column = nil

  ATTRIBUTE_WHITELIST = [
    :previous_payment,
    :updated_payment,
    :reason,
    :type
  ].freeze

  TYPES = {
    paid:    0,
    pending: 1
  }.freeze

  enum type: TYPES

  belongs_to :user
  belongs_to :consultation

  validates_presence_of :previous_payment,
                        :updated_payment,
                        :reason

  before_save :normalize
  after_save  :update_consultation

  private

  def normalize
    normalize_fields :reason
  end

  def update_consultation
    if paid?
      consultation.update(payment: updated_payment)
    else
      consultation.update(pending_payment: updated_payment)
    end
  end
end
