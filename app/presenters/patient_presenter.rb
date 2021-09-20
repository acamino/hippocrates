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

  def gender_es
    if male?
      'Masculino'
    else
      'Femenino'
    end
  end

  def civil_status_es
    if male?
      civil_status_male_es[civil_status]
    else
      civil_status_female_es[civil_status]
    end
  end

  def anamnesis?
    anamnesis.present?
  end

  def consultations?
    consultations.present?
  end

  private

  def civil_status_male_es
    {
      'single' => 'SOLTERO',
      'married' => 'CASADO',
      'civil_union' => 'UNIÓN LIBRE',
      'divorced' => 'DIVORCIADO',
      'widowed' => 'VIUDO'
    }
  end

  def civil_status_female_es
    {
      'single' => 'SOLTERA',
      'married' => 'CASADA',
      'civil_union' => 'UNIÓN LIBRE',
      'divorced' => 'DIVORCIADA',
      'widowed' => 'VIUDA'
    }
  end
end
