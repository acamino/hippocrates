class Patient < ActiveRecord::Base
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

  before_save :normalize_values

  scope :special, -> { where(special: true) }

  def self.search(last_name, first_name)
    if last_name || first_name
      where('lower(last_name) LIKE ? AND lower(first_name) LIKE ?',
            "%#{last_name.downcase}%", "%#{first_name.downcase}%")
        .order(:last_name, :first_name)
    else
      all.order(:last_name, :first_name)
    end
  end

  def age
    if birthdate
      age = Date.today.year - birthdate.year
      return age - 1 if Date.today < birthdate + age.years
      age
    else
      0
    end
  end

  def name
    "#{last_name} #{first_name}"
  end

  def anamnesis?
    anamnesis.present?
  end

  def consultations?
    consultations.present?
  end

  private

  def normalize_values
    %w(last_name first_name address profession).each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end

    email.downcase! if email.present?
  end
end
