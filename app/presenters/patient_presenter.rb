# frozen_string_literal: true

class PatientPresenter < SimpleDelegator
  attr_writer :consultation_date

  def age
    @age ||= AgeCalculator.calculate(birthdate)
  end

  def relative_age
    AgeCalculator.calculate(birthdate, @consultation_date)
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
