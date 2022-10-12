class DiseaseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :code, key: :data
  attribute :name, key: :value
  attribute :path

  def path
    edit_disease_path(object.id)
  end
end
