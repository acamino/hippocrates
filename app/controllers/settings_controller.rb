class SettingsController < ApplicationController
  def index
    @maximum_diagnoses        = Setting.find_by(name: Setting::MAXIMUM_DIAGNOSES)
    @maximum_prescriptions    = Setting.find_by(name: Setting::MAXIMUM_PRESCRIPTIONS)
    @medical_history_sequence = Setting.find_by(name: Setting::MEDICAL_HISTORY_SEQUENCE)
  end
end
