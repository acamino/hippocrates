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
    :others
  ].freeze

  def new
    @patient      = Patient.find(params[:patient_id])
    @consultation = Consultation.new
  end

  def create
    Consultation.create(consultation_params)

    # XXX: Pull out the messages form a locale file.
    redirect_to patients_path, notice: 'Consulta creada correctamente'
  end

  private

  def consultation_params
    params.require(:consultation).permit(*ATTRIBUTE_WHITELIST).merge(
      patient_id: params[:patient_id])
  end
end
