# frozen_string_literal: true

class PatientPresenter < SimpleDelegator
  attr_writer :consultation_date

  def age
    @age ||= AgeCalculator.calculate(birthdate)
  end

  def formatted_age
    relative_age = AgeCalculator.calculate(birthdate, @consultation_date)
    years  = relative_age.years
    months = relative_age.months
    years_label  = years  == 1 ? 'AÑO' : 'AÑOS'
    months_label = months == 1 ? 'MES' : 'MESES'
    return "#{months} #{months_label}" if years.zero?
    return "#{years} #{years_label}"   if months.zero?
    "#{years} #{years_label} #{months} #{months_label}"
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
