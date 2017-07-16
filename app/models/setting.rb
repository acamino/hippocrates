class Setting < ApplicationRecord
  MAXIMUM_DIAGNOSES = 'maximum_diagnoses'.freeze
  MAXIMUM_PRESCRIPTIONS = 'maximum_prescriptions'.freeze
  MEDICAL_HISTORY_SEQUENCE = 'medical_history_sequence'.freeze

  validates_presence_of :name, :value
  validates_uniqueness_of :name
  validates_numericality_of :value, only_integer: true

  def self.maximum_diagnoses
    find_or_fail!(MAXIMUM_DIAGNOSES)
  end

  def self.maximum_prescriptions
    find_or_fail!(MAXIMUM_PRESCRIPTIONS)
  end

  def self.medical_history_sequence
    find_or_fail!(MEDICAL_HISTORY_SEQUENCE)
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

  private_class_method

  def self.find_or_fail!(setting_name)
    find_by!(name: setting_name)
  rescue ActiveRecord::RecordNotFound
    raise SettingNotFoundError, "#{setting_name} is not available"
  end
end

class SettingNotFoundError < RuntimeError; end
