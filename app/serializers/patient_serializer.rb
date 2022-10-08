class PatientSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :id,        key: :data
  attribute :full_name, key: :value
  attribute :path

  def path
    patient_consultations_path(object.id)
  end
end
