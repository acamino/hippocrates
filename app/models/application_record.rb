class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def normalize_fields(*fields)
    fields.map(&:to_s).each do |field|
      if attributes[field].present?
        public_send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
