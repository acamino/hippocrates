class Diagnosis < ActiveRecord::Base
  self.inheritance_column = nil

  enum type: [:presuntive, :definitive]

  belongs_to :consultation
end
