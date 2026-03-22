# frozen_string_literal: true

class DiseaseResource
  include Alba::Resource
  include Rails.application.routes.url_helpers

  attributes :data, :value, :path

  def data(disease)
    disease.code
  end

  def value(disease)
    disease.name
  end

  def path(disease)
    edit_disease_path(disease.id)
  end
end
