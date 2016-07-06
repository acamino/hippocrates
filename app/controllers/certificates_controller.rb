class CertificatesController < ApplicationController
  def download
    @consultation = Consultation.find(params[:consultation_id])
    send_data(certificate, download_options)
  end

  private

  def certificate
    template = Sablon.template("#{Rails.root}/public/templates/certificates/simple.docx")
    template.render_to_string(Certificate.for(@consultation).build)
  end

  def download_options
    {
      type: 'application/msword',
      disposition: 'attachment',
      filename: 'certificate.docx'
    }
  end
end
