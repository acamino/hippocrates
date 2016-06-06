class Anamnesis < ActiveRecord::Base
  belongs_to :patient

  def allergies?
    allergies.present?
  end

  def observations?
    observations.present?
  end

  def personal_history?
    personal_history.present?
  end
end
