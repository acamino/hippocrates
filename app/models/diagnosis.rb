class Diagnosis < ApplicationRecord
  self.inheritance_column = nil

  enum type: [:presuntive, :definitive]

  belongs_to :consultation

  before_save :normalize

  private

  def normalize
    normalize_fields :disease_code, :description
  end
end
