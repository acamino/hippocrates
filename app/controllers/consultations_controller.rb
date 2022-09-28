class ConsultationsController < ApplicationController
  include Trackable

  before_action :fetch_consultation, only: [:edit, :update]
  before_action :fetch_patient
  before_action :adjust_time!, only: [:update]

  def index
    delete_referer_location
    @consultations = @patient.consultations.kept.page(params.fetch(:page, 1))
  end

  def new
    @consultation = Consultation.new
    @branch_offices = BranchOffice.active.order(:active).order(:name)

    maximum_diagnoses.times     { @consultation.diagnoses.build }
    maximum_prescriptions.times { @consultation.prescriptions.build }

    store_referer_location
  end

  def create
    @consultation = Consultation.new(consultation_params)
    if @consultation.save
      track_activity(@consultation, :created)

      @patient.update(patient_params)

      redirect_to edit_patient_consultation_path(
        @patient, @consultation
      ), notice: t('consultations.success.creation')
    else
      flash[:error] = t('consultations.error.creation')
      render :new
    end
  end

  def edit
    track_activity(@consultation, :viewed)

    @branch_offices = BranchOffice.active.order(:active).order(:name)

    remaining_diagnoses.times     { @consultation.diagnoses.build }
    remaining_prescriptions.times { @consultation.prescriptions.build }

    store_referer_location
  end

  def update
    if @consultation.update(consultation_params)
      track_activity(@consultation, :updated)

      @patient.update(patient_params)
      delete_referer_location

      redirect_to edit_patient_consultation_path(
        @patient, @consultation
      ), notice: t('consultations.success.update')
    else
      flash[:error] = t('consultations.error.update')
      render :edit
    end
  end

  private

  def fetch_consultation
    @consultation = ConsultationPresenter.new(Consultation.find(params[:id]))
  end

  def remaining_diagnoses
    maximum_diagnoses - @consultation.diagnoses.count
  end

  def remaining_prescriptions
    maximum_prescriptions - @consultation.prescriptions.count
  end

  def maximum_diagnoses
    Setting.maximum_diagnoses.value.to_i
  end

  def maximum_prescriptions
    Setting.maximum_prescriptions.value.to_i
  end

  def consultation_params
    params.require(:consultation).permit(*Consultation::ATTRIBUTE_WHITELIST).merge(
      patient_id: params[:patient_id]
    ).except('patient')
  end

  def patient_params
    { special: params.dig(:consultation, :patient, :special) }
  end

  def adjust_time!
    _, time_with_timezone = @consultation.created_at.iso8601.split('T')
    time, = time_with_timezone.split('-')
    date = consultation_params[:created_at]
    params[:consultation][:created_at] = "#{date} #{time}"
  end
end
