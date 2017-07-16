class Diagnosis < ApplicationRecord
  self.inheritance_column = nil

  enum type: [:presuntive, :definitive]

  belongs_to :consultation
end
