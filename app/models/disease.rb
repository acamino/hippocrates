class Disease < ActiveRecord::Base
  self.primary_key = 'code'

  validates_presence_of :code, :name
  validates_uniqueness_of :code

  before_save :normalize_values

  private

  def normalize_values
    %w(code name).each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
