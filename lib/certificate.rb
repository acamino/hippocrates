class Certificate
  def self.for(consultation, options = {})
    new(consultation, options)
  end

  def initialize(consultation, options)
    @consultation = consultation
    @options = options
  end

  def build
    {
      patient: patient,
      consultation: consultation,
      diagnosis: diagnosis,
      definite_article: definite_article,
      current_date: current_date,
      start_time: options.fetch(:start_time, ''),
      end_time: options.fetch(:end_time, ''),
      rest_time: options.fetch(:rest_time, '')
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
