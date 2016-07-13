class ConsultationsController < ApplicationController
  ATTRIBUTE_WHITELIST = [
    :reason,
    :ongoing_issue,
    :organs_examination,
    :temperature,
    :heart_rate,
    :blood_pressure,
    :respiratory_rate,
    :weight,
    :height,
    :physical_examination,
    :right_ear,
    :left_ear,
    :right_nostril,
    :left_nostril,
    :nasopharynx,
    :nose_others,
    :oral_cavity,
    :oropharynx,
    :hypopharynx,
    :larynx,
    :neck,
    :others,
    :diagnostic_plan,
    :miscellaneous,
    :treatment_plan,
    :educational_plan,
    :next_appointment,
    :hearing_aids,
    patient: :special,
    diagnoses_attributes: [:id, :disease_code, :description, :type],
    prescriptions_attributes: [:id, :inscription, :subscription]
  ].freeze

  before_action :fetch_consultation, only: [:edit, :update]
  before_action :fetch_patient

  def index
    @consultations = @patient.consultations.page(params.fetch(:page, 1))
  end

  def new
    @consultation = Consultation.new
    maximum_diagnoses.times     { @consultation.diagnoses.build }
    maximum_prescriptions.times { @consultation.prescriptions.build }
  end

  def create
    consultation = Consultation.create(consultation_params)
    @patient.update_attributes(patient_params)

    # XXX: Pull out the messages form a locale file.
    redirect_to edit_patient_consultation_path(
      @patient, consultation), notice: 'Consulta creada correctamente'
  end

  def edit
    remaining_diagnoses.times     { @consultation.diagnoses.build }
    remaining_prescriptions.times { @consultation.prescriptions.build }
  end

  def update
    @consultation.update_attributes(consultation_params)
    @patient.update_attributes(patient_params)

    redirect_to patient_consultations_path(@patient), notice: 'Consulta actualizada correctamente'
  end

  private

  def fetch_consultation
    @consultation = Consultation.find(params[:id])
  end

  def fetch_patient
    @patient = Patient.find(params[:patient_id])
  end

  def consultation_params
    params.require(:consultation).permit(*ATTRIBUTE_WHITELIST).merge(
      patient_id: params[:patient_id]).except('patient')
  end

  def patient_params
    { special: params[:consultation][:patient][:special] }
  end

  def maximum_diagnoses
    Setting.maximum_diagnoses
  end

  def maximum_prescriptions
    Setting.maximum_prescriptions
  end

  def remaining_diagnoses
    maximum_diagnoses - @consultation.diagnoses.count
  end

  def remaining_prescriptions
    maximum_prescriptions - @consultation.prescriptions.count
  end
end
