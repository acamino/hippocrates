class Prescription < ActiveRecord::Base
  belongs_to :consultation

  validates :inscription,
            :subscription, presence: true
end
