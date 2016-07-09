class SettingsController < ApplicationController
  def index
    @maximum_diagnoses     = Setting.find_by(name: Setting::MAXIMUM_DIAGNOSES)
    @maximum_prescriptions = Setting.find_by(name: Setting::MAXIMUM_PRESCRIPTIONS)
  end
end
