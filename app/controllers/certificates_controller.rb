class CertificatesController < ApplicationController
  def download
    @consultation = Consultation.find(consultation_ids || consultation_id)
    send_data(certificate, download_options)
  end

  private

  def certificate
    template = Sablon.template(
      "#{Rails.root}/public/templates/certificates/#{certificate_type}.docx"
    )
    template.render_to_string(Certificate.for(@consultation, certificate_options))
  end

  def download_options
    {
      type: 'application/msword',
      disposition: 'attachment',
      filename: "#{certificate_type}_certificate.docx"
    }
  end

  def consultation_id
    params[:consultation_id]
  end

  def consultation_ids
    consultations = params[:consultations]
    return consultations.split('_').first if consultations.present?
  end

  def certificate_type
    params[:certificate_type]
  end

  def certificate_options
    {
      start_time: params[:start_time],
      end_time: params[:end_time],
      rest_time: params[:rest_time],
      surgical_treatment: params[:surgical_treatment],
      surgery_tentative_date: params[:surgery_tentative_date],
      surgery_cost: params[:surgery_cost],
      consultations: params[:consultations]
    }.compact
  end
end
