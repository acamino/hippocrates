# frozen_string_literal: true

class ConsultationPatientResource
  include Alba::Resource

  attributes :name, :age, :isMale

  def name(patient)
    presenter(patient).name
  end

  def age(patient)
    age = presenter(patient).age
    { years: age.years, months: age.months }
  end

  def isMale(patient)
    patient.male?
  end

  private

  def presenter(patient)
    @presenter ||= PatientPresenter.new(patient)
  end
end
