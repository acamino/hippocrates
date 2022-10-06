class PrescriptionsController < ApplicationController
  def download
    consultation     = Consultation.find(params[:consultation_id])
    emergency_number = Setting.emergency_number.value
    Prescriptions::Printer.new(consultation, emergency_number, params.fetch(:empty, false)).call
    send_file '/tmp/prescription.pdf', download_options
  end

  private

  def download_options
    {
      type:        'application/pdf',
      disposition: 'inline',
      filename:    'receta.pdf',
      status:      :accepted
    }
  end
end
