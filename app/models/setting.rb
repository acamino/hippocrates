class Setting < ApplicationRecord
  MAXIMUM_DIAGNOSES        = 'maximum_diagnoses'.freeze
  MAXIMUM_PRESCRIPTIONS    = 'maximum_prescriptions'.freeze
  MEDICAL_HISTORY_SEQUENCE = 'medical_history_sequence'.freeze
  EMERGENCY_NUMBER         = 'emergency_number'.freeze

  validates_presence_of :name, :value
  validates_uniqueness_of :name
  validates_numericality_of :value, only_integer: true, if: :require_numeric_value?

  def self.maximum_diagnoses
    find_or_fail!(MAXIMUM_DIAGNOSES)
  end

  def self.maximum_prescriptions
    find_or_fail!(MAXIMUM_PRESCRIPTIONS)
  end

  def self.medical_history_sequence
    find_or_fail!(MEDICAL_HISTORY_SEQUENCE)
  end

  def self.emergency_number
    find_or_fail!(EMERGENCY_NUMBER)
  end

  def self.find_or_fail!(setting_name)
    find_by!(name: setting_name)
  rescue ActiveRecord::RecordNotFound
    raise SettingNotFoundError, "#{setting_name} is not available"
  end

  class MedicalHistorySequence
    def self.next
      Setting.medical_history_sequence.value.to_i.succ
    end

    def save
      setting = Setting.medical_history_sequence
      setting.value = setting.value.to_i.succ.to_s
      setting.save
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

class SettingNotFoundError < RuntimeError; end
