class PatientSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :id,                   key: :data
  attribute :full_name,            key: :value
  attribute :identity_card_number, key: :identityCardNumber
  attribute :male?,                key: :isMale
  attribute :age
  attribute :path

  def identity_card_number
    patient.identity_card_number
  end

  def age
    patient.age.years
  end

  def path
    patient_consultations_path(object.id)
  end

  private

  def patient
    PatientPresenter.new(object)
  end
end
