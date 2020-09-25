class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def normalize_fields(*fields)
    fields.map(&:to_s).each do |field|
      public_send("#{field}=", UnicodeUtils.upcase(attributes[field])) if attributes[field].present?
    end
  end
end
