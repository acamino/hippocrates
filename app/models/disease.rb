class Disease < ActiveRecord::Base
  self.primary_key = 'code'

  validates_presence_of :code, :name
  validates_uniqueness_of :code

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
    %w(code name).each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
