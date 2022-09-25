class AnamnesesController < ApplicationController
  include Trackable

  before_action :fetch_patient, only: [:new, :edit]

  def new
    @anamnesis = Anamnesis.new
  end

  def create
    @anamnesis = Anamnesis.create(anamnesis_params)

    track_activity(@anamnesis, :created)

    redirect_to(
      new_patient_consultation_path(params[:patient_id]),
      notice: t('anamneses.success.creation')
    )
  end

  def edit
    @anamnesis = Anamnesis.find(params[:id])

    track_activity(@anamnesis, :viewed)

    @referer_location = referer_location
  end

  def update
    @anamnesis = Anamnesis.find(params[:id])
    @anamnesis.update_attributes(anamnesis_params)

    track_activity(@anamnesis, :updated)

    if referer_location
      redirect_to referer_location
    else
      redirect_to patients_path, notice: t('anamneses.success.update')
    end
  end

  private

  def anamnesis_params
    params.require(:anamnesis).permit(*Anamnesis::ATTRIBUTE_WHITELIST).merge(
      patient_id: params[:patient_id]
    )
  end
end
