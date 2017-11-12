require 'timecop'
require_relative '../../app/lib/age_calculator'

describe AgeCalculator do
  it 'calculates age in years and months' do
    Timecop.freeze('2011-07-29') do
      age = described_class.calculate(Date.new(1979, 9, 10))
      expect(age.years).to eq(31)
      expect(age.months).to eq(11)
    end
  end
end
