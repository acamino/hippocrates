class Medicine < ActiveRecord::Base
  validates :name,
            :instructions, presence: true

  validates :name, uniqueness: true

  before_save :normalize_values

  private

  def normalize_values
    %w(name instructions).each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
