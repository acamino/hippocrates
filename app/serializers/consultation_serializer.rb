class ConsultationSerializer < ActiveModel::Serializer
  attributes :id, :reason, :date
  attribute :has_diagnoses, key: :hasDiagnoses
  attribute :has_prescriptions, key: :hasPrescriptions

  has_one :patient
  has_many :diagnoses
  has_many :prescriptions

  def has_diagnoses
    object.diagnoses.count > 0
  end

  def has_prescriptions
    object.prescriptions.count > 0
  end

  def date
    object.created_at.strftime("%Y-%m-%d")
  end

  class PatientSerializer < ActiveModel::Serializer
    attributes :name, :age

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
