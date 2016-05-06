class PatientsController < ApplicationController
  ATTRIBUTE_WHITELIST = [
    :medical_history,
    :identity_card_number,
    :first_name,
    :last_name,
    :birthdate,
    :gender,
    :civil_status,
    :source,
    :profession
  ].freeze

  def index
    # XXX: Add pagination
    # XXX: Move all.sort to the model. This controller knows so much :)
    @patients = Patient.search(params[:search])
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      # XXX: Pull out the messages form a locale file.
      redirect_to patients_path, notice: 'Paciente creado correctamente'
    else
      render :new
    end
  end

  def edit
    @patient = Patient.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    if @patient.update_attributes(patient_params)
      redirect_to patients_path, notice: 'Paciente actualizado correctamente'
    else
      render :edit
    end
  end

  private

  def patient_params
    params.require(:patient).permit(*ATTRIBUTE_WHITELIST)
  end
end
