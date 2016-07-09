class Setting < ActiveRecord::Base
  MAXIMUM_DIAGNOSES = 'maximum_diagnoses'.freeze
  MAXIMUM_PRESCRIPTIONS = 'maximum_prescriptions'.freeze
  MEDICAL_HISTORY_SEQUENCE = 'medical_history_sequence'.freeze

  validates_presence_of :name, :value
  validates_uniqueness_of :name

  [MAXIMUM_DIAGNOSES, MAXIMUM_PRESCRIPTIONS].each do |setting_name|
    define_singleton_method setting_name do
      find_by(name: setting_name).value.to_i
    end
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
