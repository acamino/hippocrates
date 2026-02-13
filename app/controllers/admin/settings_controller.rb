module Admin
  class SettingsController < ApplicationController
    before_action :authorize_admin_access

    def index
      @maximum_diagnoses        = Setting.maximum_diagnoses
      @maximum_prescriptions    = Setting.maximum_prescriptions
      @medical_history_sequence = Setting.medical_history_sequence
      @emergency_number         = Setting.emergency_number
      @website                  = Setting.website
    end

    private

    def authorize_admin_access
      authorize :admin
    end
  end
end
