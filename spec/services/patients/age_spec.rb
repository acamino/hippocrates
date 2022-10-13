require 'timecop'
require_relative '../../../app/services/patients/age'

describe Patients::Age do
  context 'when date is *NOT* passed' do
    it 'calculates age in years and months' do
      Timecop.freeze('2011-07-29') do
        age = described_class.from(Date.new(1979, 9, 10))
        expect(age.years).to eq(31)
        expect(age.months).to eq(11)
      end
    end
  end

  context 'when date is passed' do
    it 'calculates age in years and months' do
      age = described_class.from(Date.new(1979, 9, 10), Date.new(2011, 7, 29))
      expect(age.years).to eq(31)
      expect(age.months).to eq(11)
    end
  end
end
