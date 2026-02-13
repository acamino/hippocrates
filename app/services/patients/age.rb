module Patients
  class Age
    attr_reader :birthday

    def self.from(birthday, date = Date.today)
      new(birthday, date || Date.today).years_and_months
    end

    def initialize(birthday, date)
      @birthday = birthday
      @date     = date
    end

    def years_and_months
      age = Struct.new(:years, :months)

      return age.new(0, 0) unless birthday
      age.new(years, months)
    end

    private

    def years
      y = @date.year - birthday.year
      y -= 1 if before_birthday_in_year?
      y
    end

    def months
      m = @date.month - birthday.month
      m -= 1 if @date.day < birthday.day
      m += 12 if m.negative?
      m
    end

    def before_birthday_in_year?
      @date.month < birthday.month ||
        (@date.month == birthday.month && @date.day < birthday.day)
    end
  end
end
