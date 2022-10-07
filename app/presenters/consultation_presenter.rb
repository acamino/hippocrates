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
    I18n.localize(created_at, format: '%d de %B de %Y')
  end

  def pretty_payment
    format('%.2f', payment)
  end

  def pretty_pending_payment
    format('%.2f', pending_payment)
  end

  def pretty_total_payment
    format('%.2f', payment - pending_payment)
  end

  def pretty_diagnoses
    diagnoses.map do |diagnosis|
      "#{diagnosis.description.strip} (#{diagnosis.disease_code.strip})"
    end.join(', ')
  end

  def next_appointment_date
    next_appointment&.strftime('%F')
  end

  def next_appointment_long_date
    next_appointment&.strftime('%b %d, %Y')
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

  def user_id
    doctor&.id || current_user.id
  end

  def doctors
    User.active_doctor.pluck(:pretty_name, :id)
  end
end
