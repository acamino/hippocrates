class Medicine < ApplicationRecord
  validates :name,
            :instructions, presence: true

  validates :name, uniqueness: true

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
    normalize_fields :name, :instructions
  end
end
