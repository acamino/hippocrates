class Anamnesis < ActiveRecord::Base
  belongs_to :patient

  before_save :normalize_values

  def allergies?
    allergies.present?
  end

  def observations?
    observations.present?
  end

  def medical_history?
    medical_history.present?
  end

  private

  def normalize_values
    %w(medical_history surgical_history allergies observations habits
       family_history).each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
