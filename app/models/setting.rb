class Setting < ApplicationRecord
  EMERGENCY_NUMBER         = 'emergency_number'.freeze
  MAXIMUM_DIAGNOSES        = 'maximum_diagnoses'.freeze
  MAXIMUM_PRESCRIPTIONS    = 'maximum_prescriptions'.freeze
  MEDICAL_HISTORY_SEQUENCE = 'medical_history_sequence'.freeze
  WEBSITE                  = 'website'.freeze

  validates :name, presence: true, uniqueness: true
  validates :value, presence: true
  validates :value, numericality: { only_integer: true }, if: :require_numeric_value?

  def self.emergency_number
    fetch(EMERGENCY_NUMBER) { |setting| setting.value = 'EMERGENCY NUMBER' }
  end

  def self.maximum_diagnoses
    fetch(MAXIMUM_DIAGNOSES) { |setting| setting.value = 5 }
  end

  def self.maximum_prescriptions
    fetch(MAXIMUM_PRESCRIPTIONS) { |setting| setting.value = 5 }
  end

  def self.medical_history_sequence
    fetch(MEDICAL_HISTORY_SEQUENCE) { |setting| setting.value = 0 }
  end

  def self.website
    fetch(WEBSITE) { |setting| setting.value = 'WEBSITE' }
  end

  def self.fetch(setting_name, &)
    find_or_create_by(name: setting_name, &)
  end

  class MedicalHistorySequence
    def self.next
      Setting.medical_history_sequence.value.to_i.succ
    end

    def self.next!
      setting = Setting.medical_history_sequence
      setting.with_lock do
        setting.value = setting.value.to_i.succ.to_s
        setting.save!
      end
      setting.value.to_i
    end
  end

  private

  def require_numeric_value?
    [
      MAXIMUM_DIAGNOSES,
      MAXIMUM_PRESCRIPTIONS,
      MEDICAL_HISTORY_SEQUENCE
    ].include?(name)
  end
end
