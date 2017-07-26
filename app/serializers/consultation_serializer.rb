class ConsultationSerializer < ActiveModel::Serializer
  attributes :id, :reason, :date, :next_appointment
  attribute :diagnoses?, key: :hasDiagnoses
  attribute :prescriptions?, key: :hasPrescriptions
  attribute :next_appointment?, key: :hasNextAppointment

  has_one :patient
  has_many :diagnoses
  has_many :prescriptions

  def diagnoses?
    consultation_presenter.diagnoses?
  end

  def prescriptions?
    consultation_presenter.prescriptions?
  end

  def date
    consultation_presenter.date
  end

  def next_appointment?
    consultation_presenter.next_appointment?
  end

  def next_appointment
    return consultation_presenter.next_appointment_date if consultation_presenter.next_appointment?
  end

  class PatientSerializer < ActiveModel::Serializer
    attributes :name, :age
    attribute :male?, key: :isMale

    def name
      patient_presenter.name
    end

    def age
      patient_presenter.age
    end

    private

    def patient_presenter
      PatientPresenter.new(object)
    end
  end

  class DiagnosisSerializer < ActiveModel::Serializer
    attributes :description, :type
    attribute :disease_code, key: :diseaseCode
  end

  class PrescriptionSerializer < ActiveModel::Serializer
    attributes :inscription, :subscription
  end

  private

  def consultation_presenter
    ConsultationPresenter.new(object)
  end
end
