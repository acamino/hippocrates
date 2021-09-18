class Certificate
  def self.for(consultation, options = {})
    new(consultation, options).build
  end

  def initialize(consultation, options)
    @consultation = consultation
    @options      = options
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def build
    {
      patient: patient,
      consultation: ConsultationPresenter.new(consultation),
      definite_article: definite_article,
      current_date: current_date,
      start_time: options.fetch(:start_time, ''),
      end_time: options.fetch(:end_time, ''),
      rest_time: options.fetch(:rest_time, ''),
      surgical_treatment: options.fetch(:surgical_treatment, '').upcase,
      surgery_tentative_date: options.fetch(:surgery_tentative_date, '').upcase,
      surgery_cost: options.fetch(:surgery_cost, ''),
      consultations: consultations,
      doctor: consultation.doctor
    }
  end

  private

  attr_reader :consultation, :options

  def patient
    PatientPresenter.new(consultation.patient).tap do |p|
      p.consultation_date = consultation&.created_at&.to_date
    end
  end

  def definite_article
    patient.male? ? 'el' : 'la'
  end

  def current_date
    I18n.localize(Date.today, format: :long)
  end

  def consultations
    patient_consultations = patient.consultations.reverse.map do |c|
      ConsultationPresenter.new(c)
    end
    selected_consultations = patient_consultations.select do |c|
      selected_consultations_ids.include? c.id
    end

    first_consultation_id = patient_consultations.first.id
    selected_consultations.each { |c| c.head = c.id == first_consultation_id }
  end

  def selected_consultations_ids
    options.fetch(:consultations, '').split('_').map(&:to_i)
  end
end
