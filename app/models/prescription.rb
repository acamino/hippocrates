class Prescription < ApplicationRecord
  belongs_to :consultation

  validates :inscription,
            :subscription, presence: true

  before_save :normalize

  default_scope { order(id: :asc) }

  def normalize
    normalize_fields :inscription,
                     :subscription
  end
end
