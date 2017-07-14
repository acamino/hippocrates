# frozen_string_literal: true

class PatientPresenter < SimpleDelegator
  def formatted_birthdate
    if new_record?
      ''
    else
      birthdate.strftime('%F')
    end
  end
end
