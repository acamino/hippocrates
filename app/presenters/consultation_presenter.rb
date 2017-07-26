# frozen_string_literal: true

class ConsultationPresenter < SimpleDelegator
  def date
    created_at.strftime('%F')
  end

  def long_date
    created_at.strftime('%b %d, %Y')
  end

  def time
    created_at.strftime('%I:%M %p')
  end

  def pretty_date
    I18n.localize(created_at, format: '%B %d de %Y')
  end

  def next_appointment_date
    next_appointment.strftime('%F')
  end

  def next_appointment_long_date
    next_appointment.strftime('%b %d, %Y')
  end

  def next_appointment?
    next_appointment.present?
  end

  def diagnoses?
    diagnoses.count.positive?
  end

  def prescriptions?
    prescriptions.count.positive?
  end

  def miscellaneous?
    miscellaneous.present?
  end
end
