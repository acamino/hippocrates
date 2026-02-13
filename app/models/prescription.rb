class Prescription < ApplicationRecord
  belongs_to :consultation

  validates :inscription,
            :subscription, presence: true

  before_save :normalize

  def normalize
    normalize_fields :inscription,
                     :subscription
  end
end
