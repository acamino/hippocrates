class SpecialPatientsController < ApplicationController
  def index
    @consultations = Consultation.includes(:patient).most_recent_for_special_patients
  end

  def remove
    patient = Patient.find(params[:id])
    patient.update_attributes(special: false)
    redirect_to special_patients_path, notice: t('patients.special.remove.success')
  end
end
