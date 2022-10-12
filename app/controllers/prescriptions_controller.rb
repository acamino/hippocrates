class PrescriptionsController < ApplicationController
  before_action :fetch_consultation

  def download
    Prescriptions::Printer.call(@consultation, params.fetch(:empty, false))
    send_file '/tmp/prescription.pdf', download_options
  end

  private

  def fetch_consultation
    @consultation = Consultation.find(params[:consultation_id])
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
