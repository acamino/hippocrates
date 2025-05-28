class Patient < ApplicationRecord
  include Discard::Model
  include PgSearch::Model
  include PublicActivity::Model

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
    :health_insurance,
    :branch_office_id,
    :data_management_consent
  ].freeze

  enum gender: [:male, :female]
  enum civil_status: [:single, :married, :civil_union, :divorced, :widowed]
  enum source: [
    :television,
    :radio,
    :newspaper,
    :patient_reference,
    :instagram,
    :facebook,
    :tiktok,
    :health_professional
  ]

  belongs_to :branch_office, optional: true

  has_one :anamnesis

  has_one :most_recent_consultation, lambda {
    merge(Consultation.kept.most_recent_by_patient)
  }, class_name: 'Consultation', inverse_of: :patient

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

  before_save :normalize

  scope :special, -> { includes(:consultations).where(special: true) }
  scope :order_by_name, -> { empty_names_to_end.order(:last_name, :first_name) }
  scope :empty_names_to_end, -> { order(Arel.sql("first_name = '', last_name = ''")) }

  pg_search_scope :lookup,
    against:  [:first_name, :last_name, :identity_card_number],
    using:    { tsearch: { prefix: true } },
    ignoring: :accents

  def self.search(query)
    (query.present? ? lookup(query) : all).order_by_name
  end

  def self.source_options
    [
      ['Instagram', 'instagram'],
      ['Facebook', 'facebook'],
      ['Tiktok', 'tiktok'],
      ['Televisión', 'television'],
      ['Radio', 'radio'],
      ['Otro paciente', 'patient_reference'],
      ['Personal de salud', 'health_professional'],
      ['Periódico', 'newspaper'],
    ].freeze
  end

  def archive
    ApplicationRecord.transaction do
      consultations.discard_all
      anamnesis&.discard
      discard

      update(identity_card_number: "#{DateTime.now.strftime('%Q')}__#{identity_card_number}")
    end
  end

  def full_name
    [last_name, first_name].join(' ')
  end

  def data_management_consent_required_for_consultation?
    data_management_consent != true
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
