class Consultation < ActiveRecord::Base
  belongs_to :patient
  has_many   :diagnoses
  has_many   :prescriptions

  accepts_nested_attributes_for :diagnoses,
                                reject_if: -> (attributes) { attributes[:description].blank? },
                                allow_destroy: true

  accepts_nested_attributes_for :prescriptions,
                                reject_if: -> (attributes) { attributes[:inscription].blank? },
                                allow_destroy: true

  scope :ordered_by_date, -> { order(created_at: :asc) }

  def self.most_recent
    ordered_by_date.last
  end

  def miscellaneous?
    miscellaneous.present?
  end

  def next_appointment?
    next_appointment.present?
  end
end
