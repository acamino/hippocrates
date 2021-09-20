# rubocop:disable Metrics/ClassLength
class Consultation < ApplicationRecord
  ATTRIBUTE_WHITELIST = [
    :reason,
    :ongoing_issue,
    :organs_examination,
    :temperature,
    :heart_rate,
    :blood_pressure,
    :respiratory_rate,
    :weight,
    :height,
    :oxygen_saturation,
    :physical_examination,
    :right_ear,
    :left_ear,
    :right_nostril,
    :left_nostril,
    :nasopharynx,
    :nose_others,
    :oral_cavity,
    :oropharynx,
    :hypopharynx,
    :larynx,
    :neck,
    :others,
    :hearing_aids,
    :diagnostic_plan,
    :miscellaneous,
    :treatment_plan,
    :warning_signs,
    :recommendations,
    :next_appointment,
    :created_at,
    patient: :special,
    diagnoses_attributes: [:id, :disease_code, :description, :type, :_destroy],
    prescriptions_attributes: [:id, :inscription, :subscription, :_destroy]
  ].freeze

  belongs_to :doctor, class_name: 'User', foreign_key: 'user_id'
  belongs_to :patient

  has_many   :diagnoses,     dependent: :destroy
  has_many   :documents,     dependent: :destroy
  has_many   :prescriptions, dependent: :destroy

  accepts_nested_attributes_for :diagnoses,
                                reject_if: ->(attributes) { attributes[:description].blank? },
                                allow_destroy: true

  accepts_nested_attributes_for :prescriptions,
                                reject_if: ->(attributes) { attributes[:inscription].blank? },
                                allow_destroy: true

  before_save :normalize

  after_create :update_serial!

  default_scope { order(created_at: :desc) }

  attr_accessor :head

  scope :most_recent_by_patient, lambda {
    from(
      <<~SQL
        (
          SELECT consultations.*
          FROM consultations JOIN (
             SELECT patient_id, max(created_at) AS created_at
             FROM consultations
             GROUP BY patient_id
          ) latest_by_patient
          ON consultations.created_at = latest_by_patient.created_at
          AND consultations.patient_id = latest_by_patient.patient_id
        ) consultations
      SQL
    )
  }

  scope :most_recent_for_special_patients, lambda {
    most_recent_by_patient
      .joins(:patient)
      .where(patients: { special: true })
      .order('consultations.created_at')
  }

  %w[right_ear left_ear left_nostril right_nostril nasopharynx
     nose_others oral_cavity oropharynx hypopharynx larynx neck
     others].each do |method_name|
    define_method(method_name) do
      value = self[method_name]

      return 'NORMAL' if value.blank?
      value
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def normalize
    normalize_fields :reason,
                     :ongoing_issue,
                     :organs_examination,
                     :physical_examination,
                     :right_ear,
                     :left_ear,
                     :right_nostril,
                     :left_nostril,
                     :nasopharynx,
                     :nose_others,
                     :oral_cavity,
                     :oropharynx,
                     :hypopharynx,
                     :larynx,
                     :neck,
                     :others,
                     :miscellaneous,
                     :diagnostic_plan,
                     :treatment_plan,
                     :warning_signs,
                     :recommendations,
                     :hearing_aids
  end

  def update_serial!
    serial = doctor.next_serial!
    self.serial = serial.to_s.rjust(5, '0')

    save!
  end
end
