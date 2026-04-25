# frozen_string_literal: true

class ConsultationPresenter < SimpleDelegator
  def date
    created_at.strftime('%Y/%m/%d')
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
    format_amount(payment)
  end

  def pretty_pending_payment
    format_amount(pending_payment)
  end

  def pending_payment?
    pending_payment.positive?
  end

  def pretty_total_payment
    format_amount(payment - pending_payment)
  end

  def pretty_diagnoses
    @pretty_diagnoses ||= diagnoses.map do |diagnosis|
      "#{diagnosis.description.strip} (#{diagnosis.disease_code.strip})"
    end.join(', ')
  end

  def next_appointment_date
    next_appointment&.strftime('%Y/%m/%d')
  end

  def next_appointment_long_date
    next_appointment&.strftime('%b %d, %Y')
  end

  def next_appointment?
    next_appointment.present?
  end

  def diagnoses?
    diagnoses.size.positive?
  end

  def prescriptions?
    prescriptions.size.positive?
  end

  def miscellaneous?
    miscellaneous.present?
  end

  def user_id
    doctor&.id || current_user.id
  end

  private

  def format_amount(value)
    ActiveSupport::NumberHelper.number_to_rounded(value, precision: 2, delimiter: '.')
  end
end
