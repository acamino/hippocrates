class PrescriptionsController < ApplicationController
  before_action :fetch_patient, :fetch_consultation

  def download
    pdf_data = Prescriptions::Printer.call(@consultation, params.fetch(:empty, false))
    send_data pdf_data, download_options
  end

  private

  def fetch_consultation
    @consultation = @patient.consultations
                            .includes(:doctor, :branch_office, :diagnoses,
                                      :prescriptions, patient: :anamnesis)
                            .find(params[:consultation_id])
  end

  def filename
    now = Time.zone.now.strftime('%Y_%m_%d_%H_%M_%S')
    patient_name = @consultation.patient.full_name.downcase.gsub(/\s+/, '_')
    "prescription_#{patient_name}_#{now}.pdf"
  end

  def download_options
    {
      type:        'application/pdf',
      disposition: 'inline',
      filename:    filename,
      status:      :accepted
    }
  end
end
