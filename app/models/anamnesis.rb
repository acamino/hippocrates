class Anamnesis < ActiveRecord::Base
  belongs_to :patient

  def allergies?
    allergies.present?
  end

  def observations?
    observations.present?
  end

  def medical_history?
    medical_history.present?
  end
end
