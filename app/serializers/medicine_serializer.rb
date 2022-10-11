class MedicineSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :name,         key: :value
  attribute :instructions, key: :data
  attribute :path

  def path
    edit_medicine_path(object.id)
  end
end
