class AgeCalculator
  attr_reader :birthday

  def self.calculate(birthday, date = Date.today)
    new(birthday, date).years_and_months
  end

  def initialize(birthday, date)
    @birthday = birthday
    @date     = date || Date.today
  end

  def years_and_months
    age = Struct.new(:years, :months)

    return age.new(0, 0) unless birthday
    age.new(years, (age_in_days % 365) / 30)
  end

  private

  def age_in_days
    (@date - Date.new(birthday.year, birthday.month, birthday.day)).to_i
  end

  def years
    age_in_days / 365
  end
end
