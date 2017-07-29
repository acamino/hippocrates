# frozen_string_literal: true

class PatientPresenter < SimpleDelegator
  def age
    AgeCalculator.calculate(birthdate)
  end

  def formatted_birthdate
    if new_record?
      ''
    else
      birthdate.strftime('%F')
    end
  end

  def name
    "#{last_name} #{first_name}"
  end

  def most_recent_consultation
    ConsultationPresenter.new(consultations.most_recent)
  end

  def anamnesis?
    anamnesis.present?
  end

  def consultations?
    consultations.present?
  end
end
