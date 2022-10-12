class PatientsController < ApplicationController
  include Trackable

  before_action :authorize_admin, only: [:export]

  def export
    patients    = Patient.includes(:anamnesis).kept.order(:last_name, :first_name)
    spreadsheet = Patients::Excel::Builder.call(patients, Time.zone.now)
    send_data(spreadsheet.to_stream.read, download_options)
  end

  def index
    delete_referer_location
    @patients = Patient.kept.includes(:consultations, :anamnesis).search(params[:query]).page(page)
  end

  def new
    @patient = PatientPresenter.new(Patient.new)
    @patient.medical_history = Setting::MedicalHistorySequence.next
    @branch_offices = BranchOffice.active.order(:active).order(:name)
  end

  # rubocop:disable Metrics/MethodLength
  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      track_activity(@patient, :created)

      Setting::MedicalHistorySequence.new.save

      redirect_to new_patient_anamnesis_path(
        @patient
      ), notice: t('patients.success.creation')
    else
      @branch_offices = BranchOffice.active.order(:active).order(:name)
      render :new
    end
  end

  def edit
    @patient = PatientPresenter.new(Patient.find(params[:id]))
    @branch_offices = BranchOffice.active.order(:active).order(:name)

    track_activity(@patient, :viewed)

    @referer_location = referer_location
  end

  # rubocop:disable Metrics/AbcSize
  def update
    @patient = Patient.find(params[:id])
    if @patient.update(patient_params)
      track_activity(@patient, :updated)

      if referer_location
        redirect_to referer_location
      else
        redirect_to patients_path, notice: t('patients.success.update', name: @patient.full_name)
      end
    else
      @branch_offices = BranchOffice.active.order(:active).order(:name)
      render :edit
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.archive

    track_activity(@patient, :deleted)

    redirect_to patients_path, notice: t('patients.success.destroy', name: @patient.full_name)
  end

  private

  def patient_params
    params.require(:patient).permit(*Patient::ATTRIBUTE_WHITELIST)
  end

  def download_options
    {
      type:        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      disposition: 'attachment',
      filename:    "patients_#{Time.zone.now.strftime('%Y_%m_%d_%H_%M_%S')}.xlsx"
    }
  end
end
