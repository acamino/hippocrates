class Patient < ActiveRecord::Base
  enum gender: { male: 0, female: 1 }
  enum civil_status: { single: 0, married: 1, civil_union: 2, divorced: 3, widowed: 4 }
  enum source: { television: 0, radio: 1, newspaper: 2, patient_reference: 3 }

  has_one :anamnesis

  validates :medical_history,
            :last_name,
            :first_name,
            :identity_card_number,
            :birthdate,
            :gender,
            :civil_status,
            :source, presence: true

  validates :medical_history,
            :identity_card_number, uniqueness: true
  validates :email, uniqueness: true, allow_nil: true, allow_blank: true

  def self.search(query)
    if query
      where('lower(last_name) LIKE ?', "%#{query.downcase}%").order(:last_name, :first_name)
    else
      all.order(:last_name, :first_name)
    end
  end

  def age
    if birthdate
      now = Time.now.utc.to_date
      now.year - birthdate.year - ((now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day)) ? 0 : 1)
    else
      0
    end
  end
end
