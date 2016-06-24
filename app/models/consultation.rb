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

  before_save :normalize_values

  default_scope { order(created_at: :desc) }

  def self.most_recent
    first
  end

  def miscellaneous?
    miscellaneous.present?
  end

  def next_appointment?
    next_appointment.present?
  end

  private

  def normalize_values
    %w(reason ongoing_issue organs_examination physical_examination
       right_ear left_ear right_nostril left_nostril nasopharynx
       nose_others oral_cavity oropharynx hypopharynx larynx
       neck others miscellaneous diagnostic_plan treatment_plan
       educational_plan).each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
