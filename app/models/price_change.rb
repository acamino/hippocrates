class PriceChange < ApplicationRecord
  ATTRIBUTE_WHITELIST = [
    :updated_price,
    :reason
  ].freeze

  belongs_to :user
  belongs_to :consultation

  validates_presence_of :previous_price,
                        :updated_price,
                        :reason

  before_save :normalize

  private

  def normalize
    normalize_fields :reason
  end
end
