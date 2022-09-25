class Anamnesis < ApplicationRecord
  include PublicActivity::Model

  ATTRIBUTE_WHITELIST = [
    :medical_history,
    :surgical_history,
    :allergies,
    :observations,
    :habits,
    :family_history,
    :hearing_aids
  ].freeze

  belongs_to :patient

  before_save :normalize

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

  def normalize
    normalize_fields :medical_history,
                     :surgical_history,
                     :allergies,
                     :observations,
                     :habits,
                     :family_history
  end
end
