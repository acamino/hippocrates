class DiseaseSerializer < ActiveModel::Serializer
  attributes :value, :data

  def value
    object.name
  end

  def data
    object.code
  end
end
