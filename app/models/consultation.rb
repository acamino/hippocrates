class Consultation < ActiveRecord::Base
  belongs_to :patient
  has_many   :diagnoses
end
