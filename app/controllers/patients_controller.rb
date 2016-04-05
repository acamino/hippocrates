class PatientsController < ApplicationController
  ATTRIBUTE_WHITELIST = [
    :medical_history,
    :identity_card_number,
    :first_name,
    :last_name,
    :birthdate,
    :gender,
    :civil_status,
    :source
  ]

  def index
    # XXX: Sort the patients alphabetically
    # XXX: Add pagination
    @patients = Patient.all
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_attributes)
    if @patient.save
      redirect_to patients_path
    else
      render :new
    end
  end

  private

  def patient_attributes
    params.require(:patient).permit(*ATTRIBUTE_WHITELIST)
  end
end
