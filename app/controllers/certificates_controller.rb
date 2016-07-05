class CertificatesController < ApplicationController
  def download
    @consultation = Consultation.find(params[:consultation_id])

    template = Sablon.template("#{Rails.root}/public/templates/certificates/simple.docx")
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
      definite_article: definite_article,
      patient_name: patient.name,
      identity_card_number: patient.identity_card_number,
      disease: "#{diagnosis.description} (#{diagnosis.disease_code})",
      date: date
    }
  end
end
