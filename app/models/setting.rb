class Setting < ActiveRecord::Base
  MAXIMUM_DIAGNOSES = 'maximum_diagnoses'
  MAXIMUM_PRESCRIPTIONS = 'maximum_prescriptions'

  validates_presence_of :name, :value
  validates_uniqueness_of :name

  [MAXIMUM_DIAGNOSES, MAXIMUM_PRESCRIPTIONS].each do |setting_name|
    define_singleton_method setting_name do
      find_by(name: setting_name).value.to_i
    end
  end
end
