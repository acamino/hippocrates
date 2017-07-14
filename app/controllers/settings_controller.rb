class SettingsController < ApplicationController
  def index
    @maximum_diagnoses        = Setting.maximum_diagnoses
    @maximum_prescriptions    = Setting.maximum_prescriptions
    @medical_history_sequence = Setting.medical_history_sequence
  end
end
