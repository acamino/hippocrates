class Medicine < ApplicationRecord
  include PgSearch::Model

  ATTRIBUTE_WHITELIST = [
    :name,
    :instructions
  ].freeze

  validates :name,
            :instructions, presence: true

  validates :name, uniqueness: true

  before_save :normalize

  pg_search_scope :lookup,
    against:  :name,
    using:    { tsearch: { prefix: true } },
    ignoring: :accents

  def self.search(query)
    (query.present? ? lookup(query) : all).order(:name)
  end

  private

  def normalize
    normalize_fields :name, :instructions
  end
end
