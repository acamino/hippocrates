class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def normalize_fields(*fields)
    fields.map(&:to_s).each do |field|
      value = attributes[field]
      public_send("#{field}=", UnicodeUtils.upcase(value.strip)) if value.present?
    end
  end
end
