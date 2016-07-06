class Certificate
  def self.for(consultation, options = {})
    new(consultation, options)
  end

  def initialize(consultation, options)
    @consultation = consultation
    @options = options
  end

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/AbcSize
  def build
    {
      definite_article: definite_article,
      patient_name: patient.name,
      patient_age: "#{patient.age} años",
      identity_card_number: patient.identity_card_number,
      disease: diagnosis.description,
      disease_code: diagnosis.disease_code,
      current_date: current_date,
      start_time: options.fetch(:start_time, ''),
      end_time: options.fetch(:end_time, ''),
      rest_time: options.fetch(:rest_time, ''),
      consultation_reason: consultation.reason
    }
  end

  private

  attr_reader :consultation, :options

  def patient
    consultation.patient
  end

  def diagnosis
    consultation.diagnoses.first
  end

  def definite_article
    patient.male? ? 'el' : 'la'
  end

  def current_date
    I18n.localize(Date.today, format: :long)
  end
end
