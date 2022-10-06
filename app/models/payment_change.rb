class PaymentChange < ApplicationRecord
  ATTRIBUTE_WHITELIST = [
    :updated_payment,
    :reason
  ].freeze

  belongs_to :user
  belongs_to :consultation

  validates_presence_of :previous_payment,
                        :updated_payment,
                        :reason

  before_save :normalize

  private

  def normalize
    normalize_fields :reason
  end
end
