class Disease < ApplicationRecord
  validates_presence_of :code, :name
  validates_uniqueness_of :code

  before_save :normalize

  def self.search(query)
    if query
      where('lower(name) LIKE ?', "%#{query.downcase}%")
        .order(:name)
    else
      all.order(:name)
    end
  end

  private

  def normalize
    normalize_fields :code, :name
  end
end
