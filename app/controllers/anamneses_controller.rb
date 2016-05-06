class AnamnesesController < ApplicationController
  ATTRIBUTE_WHITELIST = [
    :personal_history,
    :surgical_history,
    :allergies,
    :observations,
    :habits,
    :family_history
  ].freeze

  def new
    @patient   = Patient.find(params[:patient_id])
    @anamnesis = Anamnesis.new
  end

  def create
    Anamnesis.create(anamnesis_params)

    # XXX: Pull out the messages form a locale file.
    redirect_to patients_path, notice: 'Anamnesis creada correctamente'
  end

  def edit
    @patient   = Patient.find(params[:patient_id])
    @anamnesis = Anamnesis.find(params[:id])
  end

  def update
    @anamnesis = Anamnesis.find(params[:id])
    @anamnesis.update_attributes(anamnesis_params)
    redirect_to patients_path, notice: 'Anamnesis actualizada correctamente'
  end

  private

  def anamnesis_params
    params.require(:anamnesis).permit(*ATTRIBUTE_WHITELIST).merge(
      patient_id: params[:patient_id])
  end
end
