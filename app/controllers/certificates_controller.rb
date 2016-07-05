class CertificatesController < ApplicationController
  def download
    @consultation = Consultation.find(params[:consultation_id])

    template = Sablon.template("#{Rails.root}/public/templates/certificates/certificate.docx")
    certificate = template.render_to_string(context)

    send_data(certificate, type: 'application/msword',
                           disposition: 'attachment',
                           filename: 'certificate.docx')
  end

  private

  def patient
    @consultation.patient
  end

  def diagnosis
    @consultation.diagnoses.first
  end

  def definite_article
    return 'el' if patient.male?
    'la'
  end

  def date
    I18n.localize(Date.today, format: :long)
  end

  def context
    {
      article: definite_article,
      patient_name: patient.name,
      disease: diagnosis.description,
      date: date
    }
  end
end
