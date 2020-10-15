class Patient < ApplicationRecord
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
  scope :order_by_name, -> { order(:last_name, :first_name) }

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
