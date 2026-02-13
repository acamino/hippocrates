class ConsultationsController < ApplicationController
  include Trackable

  before_action :fetch_patient
  before_action :fetch_consultation, only: [:edit, :update]
  before_action :adjust_time!, only: [:update]

  def index
    delete_referer_location
    @consultations = @patient.consultations.kept.order(created_at: :desc).page(params.fetch(:page, 1))
  end

  def new
    @consultation = Consultation.new
    @doctors = User.active_doctor.pluck(:pretty_name, :id)
    @branch_offices = BranchOffice.active.order(:active).order(:name)

    maximum_diagnoses.times     { @consultation.diagnoses.build }
    maximum_prescriptions.times { @consultation.prescriptions.build }

    store_referer_location
  end

  # rubocop:disable Metrics/MethodLength
  def create
    @consultation              = Consultation.new(consultation_params.merge(**create_price_params))
    @consultation.current_user = current_user
    if @consultation.save
      track_activity(@consultation, :created)

      @patient.update(patient_params)

      redirect_to edit_patient_consultation_path(
        @patient, @consultation
      ), notice: t('consultations.success.creation')
    else
      @doctors = User.active_doctor.pluck(:pretty_name, :id)
      @branch_offices = BranchOffice.active.order(:active).order(:name)

      remaining_diagnoses.times     { @consultation.diagnoses.build }
      remaining_prescriptions.times { @consultation.prescriptions.build }

      flash[:error] = t('consultations.error.creation')
      render :new
    end
  end

  def edit
    track_activity(@consultation, :viewed)

    @doctors = User.active_doctor.pluck(:pretty_name, :id)
    @branch_offices = BranchOffice.active.order(:active).order(:name)

    remaining_diagnoses.times     { @consultation.diagnoses.build }
    remaining_prescriptions.times { @consultation.prescriptions.build }

    store_referer_location
  end

  def update
    attrs = consultation_params.merge(**update_price_params)
    attrs[:created_at] = @adjusted_created_at if @adjusted_created_at
    @consultation.current_user = current_user
    if @consultation.update(attrs)
      track_activity(@consultation, :updated)

      @patient.update(patient_params)
      delete_referer_location

      redirect_to edit_patient_consultation_path(
        @patient, @consultation
      ), notice: t('consultations.success.update')
    else
      @doctors = User.active_doctor.pluck(:pretty_name, :id)
      @branch_offices = BranchOffice.active.order(:active).order(:name)

      flash[:error] = t('consultations.error.update')
      render :edit
    end
  end

  private

  def fetch_consultation
    @consultation = ConsultationPresenter.new(
      @patient.consultations.find(params[:id])
    )
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

  def create_price_params
    { priced: current_user.doctor? }
  end

  def update_price_params
    { priced: current_user.doctor? && !@consultation.priced? }
  end

  def patient_params
    { special: params.dig(:consultation, :patient, :special) }
  end

  def adjust_time!
    date = consultation_params[:created_at]
    return if date.blank?

    time = @consultation.created_at.strftime('%H:%M:%S')
    @adjusted_created_at = "#{date} #{time}"
  end
end
