class PrescriptionsController < ApplicationController
  def download
    consultation = Consultation.find(params[:consultation_id])
    Prescriptions::Printer.new(consultation).call
    send_file '/tmp/prescription.pdf', download_options
  end

  private

  def download_options
    {
      type: 'application/pdf',
      disposition: 'inline',
      filename: 'receta.pdf',
      status: :accepted
    }
  end
end
