class MedicineSerializer < ActiveModel::Serializer
  attributes :value, :data

  def value
    object.name
  end

  def data
    object.instructions
  end
end
