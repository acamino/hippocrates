class AgeCalculator
  attr_reader :birthday

  def self.calculate(birthday)
    new(birthday).years_and_months
  end

  def initialize(birthday)
    @birthday = birthday
  end

  def years_and_months
    age = Struct.new(:years, :months)

    return age.new(0, 0) unless birthday
    age.new(years, (age_in_days % 365) / 30)
  end

  private

  def age_in_days
    (Date.today - Date.new(birthday.year, birthday.month, birthday.day)).to_i
  end

  def years
    age_in_days / 365
  end
end
