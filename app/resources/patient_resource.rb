# frozen_string_literal: true

class PatientResource
  include Alba::Resource
  include Rails.application.routes.url_helpers

  attributes :data, :value, :identityCardNumber, :isMale, :age, :path

  def data(patient)
    patient.id
  end

  def value(patient)
    patient.full_name
  end

  def identityCardNumber(patient)
    presenter(patient).identity_card_number
  end

  def isMale(patient)
    patient.male?
  end

  def age(patient)
    presenter(patient).age.years
  end

  def path(patient)
    patient_consultations_path(patient.id)
  end

  private

  def presenter(patient)
    @presenter ||= PatientPresenter.new(patient)
  end
end
