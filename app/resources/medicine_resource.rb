# frozen_string_literal: true

class MedicineResource
  include Alba::Resource
  include Rails.application.routes.url_helpers

  attributes :value, :data, :path

  def value(medicine)
    medicine.name
  end

  def data(medicine)
    medicine.instructions
  end

  def path(medicine)
    edit_medicine_path(medicine.id)
  end
end
