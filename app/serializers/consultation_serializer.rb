class ConsultationSerializer < ActiveModel::Serializer
  attributes :id, :reason, :date
  attribute :diagnoses?, key: :hasDiagnoses
  attribute :prescriptions?, key: :hasPrescriptions

  has_one :patient
  has_many :diagnoses
  has_many :prescriptions

  def diagnoses?
    object.diagnoses.count > 0
  end

  def prescriptions?
    object.prescriptions.count > 0
  end

  def date
    object.created_at.strftime('%Y-%m-%d')
  end

  class PatientSerializer < ActiveModel::Serializer
    attributes :name, :age
    attribute :male?, key: :isMale

    def name
      "#{object.last_name} #{object.first_name}"
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
