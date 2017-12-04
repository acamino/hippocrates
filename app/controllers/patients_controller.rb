# frozen_string_literal: true

class PatientsController < ApplicationController
  ATTRIBUTE_WHITELIST = [
    :medical_history,
    :identity_card_number,
    :first_name,
    :last_name,
    :birthdate,
    :gender,
    :civil_status,
    :address,
    :phone_number,
    :source,
    :profession
  ].freeze

  def special
    @patients = Patient.special.sort_by do |p|
      p.consultations.most_recent.next_appointment
    end.reverse
  end

  def remove_special
    patient = Patient.find(params[:id])
    patient.update_attributes(special: false)
    redirect_to special_patients_path, notice: t('patients.special.remove.success')
  end

  def index
    delete_referer_location
    @patients = Patient.search(params[:last_name], params[:first_name]).page(page)
  end

  def new
    @patient = PatientPresenter.new(Patient.new)
    @patient.medical_history = Setting::MedicalHistorySequence.next
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      Setting::MedicalHistorySequence.new.save
      redirect_to new_patient_anamnesis_path(
        @patient
      ), notice: t('patients.success.creation')
    else
      render :new
    end
  end

  def edit
    @patient = PatientPresenter.new(Patient.find(params[:id]))
    @referer_location = referer_location
  end

  def update
    @patient = Patient.find(params[:id])
    if @patient.update_attributes(patient_params)
      if referer_location
        redirect_to referer_location
      else
        redirect_to patients_path, notice: t('patients.success.update')
      end
    else
      render :edit
    end
  end

  private

  def patient_params
    params.require(:patient).permit(*ATTRIBUTE_WHITELIST)
  end
end
