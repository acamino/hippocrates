require 'csv'

class Patient < ApplicationRecord
  ATTRIBUTE_WHITELIST = [
    :medical_history,
    :identity_card_number,
    :first_name,
    :last_name,
    :birthdate,
    :gender,
    :civil_status,
    :address,
    :phone_number,
    :source,
    :profession,
    :email,
    :health_insurance
  ].freeze

  CSV_ATTRIBUTES = %w[
    medical_history
    last_name
    first_name
    identity_card_number
    birthdate
    gender
    civil_status
    source
  ].freeze

  enum gender: [:male, :female]
  enum civil_status: [:single, :married, :civil_union, :divorced, :widowed]
  enum source: [:television, :radio, :newspaper, :patient_reference]

  has_one  :anamnesis
  has_many :consultations

  validates :medical_history,
            :last_name,
            :first_name,
            :identity_card_number,
            :birthdate,
            :gender,
            :civil_status,
            :source, presence: true

  validates :medical_history,
            :identity_card_number, uniqueness: true
  validates :email, uniqueness: true, allow_nil: true, allow_blank: true

  before_save :normalize

  scope :special, -> { includes(:consultations).where(special: true) }
  scope :order_by_name, -> { empty_names_to_end.order(:last_name, :first_name) }
  scope :empty_names_to_end, -> { order(Arel.sql("first_name = '', last_name = ''")) }

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << (CSV_ATTRIBUTES + ['hearing_aids'])
      all.includes(:anamnesis).each do |user|
        hearing_aids = user.anamnesis&.hearing_aids || false
        csv << (user.attributes.values_at(*CSV_ATTRIBUTES) + [hearing_aids])
      end
    end
  end

  def self.search(last_name, first_name)
    if last_name.present? || first_name.present?
      where(
        'last_name ILIKE ? AND first_name ILIKE ?',
        "%#{last_name.upcase.strip}%", "%#{first_name.upcase.strip}%"
      ).order_by_name
    else
      order_by_name
    end
  end

  def full_name
    [last_name, first_name].join(' ')
  end

  private

  def normalize
    normalize_fields :last_name,
                     :first_name,
                     :address,
                     :profession,
                     :health_insurance
    email.downcase! if email.present?
  end
end
