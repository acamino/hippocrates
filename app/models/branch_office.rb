class BranchOffice < ApplicationRecord
  include PgSearch::Model

  ATTRIBUTE_WHITELIST = [
    :name,
    :main,
    :active,
    :city,
    :address,
    :phone_numbers
  ].freeze

  has_many :patients
  has_many :consultations

  validates :name, presence: true, uniqueness: true

  before_save :normalize

  scope :active, -> { where(active: true) }

  pg_search_scope :lookup,
    against:  :name,
    using:    { tsearch: { prefix: true } },
    ignoring: :accents

  def self.search(query)
    (query.present? ? lookup(query) : all).order(:name)
  end

  private

  def normalize
    normalize_fields :name
  end
end
