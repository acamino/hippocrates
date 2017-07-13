class Setting < ActiveRecord::Base
  MAXIMUM_DIAGNOSES = 'maximum_diagnoses'.freeze
  MAXIMUM_PRESCRIPTIONS = 'maximum_prescriptions'.freeze
  MEDICAL_HISTORY_SEQUENCE = 'medical_history_sequence'.freeze

  validates_presence_of :name, :value
  validates_uniqueness_of :name
  validates_numericality_of :value, only_integer: true

  def self.maximum_diagnoses
    setting = find_by(name: MAXIMUM_DIAGNOSES)
    return setting.value.to_i if setting

    raise SettingNotFoundError, 'maximun diagnoses value is not available'
  end

  def self.maximum_prescriptions
    setting = find_by(name: MAXIMUM_PRESCRIPTIONS)
    return setting.value.to_i if setting

    raise SettingNotFoundError, 'maximun prescription value is not available'
  end

  class MedicalHistorySequence
    def self.next
      setting = Setting.find_by(name: MEDICAL_HISTORY_SEQUENCE)
      setting.value.to_i.succ
    end

    def save
      setting = Setting.find_by(name: MEDICAL_HISTORY_SEQUENCE)
      setting.value = setting.value.to_i.succ.to_s
      setting.save
    end
  end
end

class SettingNotFoundError < RuntimeError; end
