class Consultation < ActiveRecord::Base
  belongs_to :patient
  has_many   :diagnoses, dependent: :destroy
  has_many   :prescriptions, dependent: :destroy

  accepts_nested_attributes_for :diagnoses,
                                reject_if: -> (attributes) { attributes[:description].blank? },
                                allow_destroy: true

  accepts_nested_attributes_for :prescriptions,
                                reject_if: -> (attributes) { attributes[:inscription].blank? },
                                allow_destroy: true

  before_save :normalize_values

  default_scope { order(created_at: :desc) }

  attr_accessor :head

  def self.most_recent
    first
  end

  %w(right_ear left_ear left_nostril right_nostril nasopharynx
     nose_others oral_cavity oropharynx hypopharynx larynx neck
     others).each do |method_name|
    define_method(method_name) do
      value = self[method_name]

      return 'NORMAL' if value.blank?
      value
    end
  end

  def date
    self[:created_at].strftime('%Y-%m-%d')
  end

  def time
    self[:created_at].strftime('%I:%M %p')
  end

  def pretty_date
    I18n.localize(self[:created_at], format: '%B %d de %Y')
  end

  def miscellaneous?
    miscellaneous.present?
  end

  def next_appointment?
    next_appointment.present?
  end

  private

  def normalize_values
    %w(reason ongoing_issue organs_examination physical_examination
       right_ear left_ear right_nostril left_nostril nasopharynx
       nose_others oral_cavity oropharynx hypopharynx larynx
       neck others miscellaneous diagnostic_plan treatment_plan
       educational_plan hearing_aids).each do |field|
      if attributes[field].present?
        send("#{field}=", UnicodeUtils.upcase(attributes[field]))
      end
    end
  end
end
