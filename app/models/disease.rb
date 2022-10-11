class Disease < ApplicationRecord
  include PgSearch::Model

  ATTRIBUTE_WHITELIST = [
    :code,
    :name
  ].freeze

  validates_presence_of :code, :name
  validates_uniqueness_of :code

  before_save :normalize

  pg_search_scope :lookup,
    against:  [:name, :code],
    using:    { tsearch: { prefix: true } },
    ignoring: :accents

  def self.search(query)
    (query.present? ? lookup(query) : all).order(Arel.sql('TRIM(name)'))
  end

  private

  def normalize
    normalize_fields :code, :name
  end
end
