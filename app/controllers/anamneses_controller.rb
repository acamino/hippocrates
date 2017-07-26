class AnamnesesController < ApplicationController
  ATTRIBUTE_WHITELIST = [
    :medical_history,
    :surgical_history,
    :allergies,
    :observations,
    :habits,
    :family_history
  ].freeze

  before_action :fetch_patient, only: [:new, :edit]

  def new
    @anamnesis = Anamnesis.new
  end

  def create
    Anamnesis.create(anamnesis_params)
    redirect_to(
      new_patient_consultation_path(params[:patient_id]),
      notice: t('anamneses.success.creation')
    )
  end

  def edit
    @anamnesis = Anamnesis.find(params[:id])
    @referer_location = referer_location
  end

  def update
    @anamnesis = Anamnesis.find(params[:id])
    @anamnesis.update_attributes(anamnesis_params)
    if referer_location
      redirect_to referer_location
    else
      redirect_to patients_path, notice: t('anamneses.success.update')
    end
  end

  private

  def anamnesis_params
    params.require(:anamnesis).permit(*ATTRIBUTE_WHITELIST).merge(
      patient_id: params[:patient_id]
    )
  end
end
