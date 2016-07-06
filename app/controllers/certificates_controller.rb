class CertificatesController < ApplicationController
  def download
    @consultation = Consultation.find(params[:consultation_id])
    send_data(certificate, download_options)
  end

  private

  def certificate
    template = Sablon.template(
      "#{Rails.root}/public/templates/certificates/#{certificate_type}.docx")
    template.render_to_string(Certificate.for(@consultation, certificate_options).build)
  end

  def download_options
    {
      type: 'application/msword',
      disposition: 'attachment',
      filename: "#{certificate_type}_certificate.docx"
    }
  end

  def certificate_type
    params[:certificate_type]
  end

  def certificate_options
    {
      start_time: params[:start_time],
      end_time: params[:end_time],
      rest_time: params[:rest_time]
    }
  end
end
