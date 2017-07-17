class ConsultationSerializer < ActiveModel::Serializer
  attributes :id, :reason, :date, :next_appointment
  attribute :diagnoses?, key: :hasDiagnoses
  attribute :prescriptions?, key: :hasPrescriptions
  attribute :next_appointment?, key: :hasNextAppointment

  has_one :patient
  has_many :diagnoses
  has_many :prescriptions

  def diagnoses?
    object.diagnoses.count.positive?
  end

  def prescriptions?
    object.prescriptions.count.positive?
  end

  def date
    object.created_at.strftime('%F')
  end

  def next_appointment?
    object.next_appointment.present?
  end

  def next_appointment
    return object.next_appointment.strftime('%F') if next_appointment?
    object.next_appointment
  end

  class PatientSerializer < ActiveModel::Serializer
    attributes :name, :age
    attribute :male?, key: :isMale

    def name
      presenter.name
    end

    def age
      presenter.age
    end

    private

    def presenter
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
end
