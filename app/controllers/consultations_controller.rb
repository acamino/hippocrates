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
    patient: :special,
    diagnoses_attributes: [:disease_code, :description, :type],
    prescriptions_attributes: [:inscription, :subscription]
  ].freeze
  MAXIMUM_DIAGNOSES = 4
  MAXIMUM_PRESCRIPTIONS = 4

  def new
    @patient      = Patient.find(params[:patient_id])
    @consultation = Consultation.new
    MAXIMUM_DIAGNOSES.times     { @consultation.diagnoses.build }
    MAXIMUM_PRESCRIPTIONS.times { @consultation.prescriptions.build }
  end

  def create
    Consultation.create(consultation_params)
    patient = Patient.find(params[:patient_id])
    patient.update_attributes(special: patient_special)

    # XXX: Pull out the messages form a locale file.
    redirect_to patients_path, notice: 'Consulta creada correctamente'
  end

  def edit
    @patient      = Patient.find(params[:patient_id])
    @consultation = Consultation.find(params[:id])
    remaining_diagnoses.times     { @consultation.diagnoses.build }
    remaining_prescriptions.times { @consultation.prescriptions.build }
  end

  private

  def consultation_params
    params.require(:consultation).permit(*ATTRIBUTE_WHITELIST).merge(
      patient_id: params[:patient_id]).except("patient")
  end

  def patient_special
    params[:consultation][:patient][:special]
  end

  def remaining_diagnoses
    MAXIMUM_DIAGNOSES - @consultation.diagnoses.count
  end

  def remaining_prescriptions
    MAXIMUM_PRESCRIPTIONS - @consultation.prescriptions.count
  end
end
