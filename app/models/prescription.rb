class Prescription < ApplicationRecord
  belongs_to :consultation

  validates :inscription,
            :subscription, presence: true

  default_scope { order(id: :asc) }
end
