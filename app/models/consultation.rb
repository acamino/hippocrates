class Consultation < ActiveRecord::Base
  belongs_to :patient
  has_many   :diagnoses

  accepts_nested_attributes_for :diagnoses,
                                reject_if: -> (attributes) { attributes[:description].blank? },
                                allow_destroy: true
end
