class Medicine < ApplicationRecord
  validates :name,
            :instructions, presence: true

  validates :name, uniqueness: true

  before_save :normalize_values

  def self.search(query)
    if query
      where('lower(name) LIKE ?', "%#{query.downcase}%")
        .order(:name)
    else
      all.order(:name)
    end
  end

  private

  def normalize_values
    %w[name instructions].each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
