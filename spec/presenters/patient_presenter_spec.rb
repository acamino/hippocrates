require 'timecop'
require_relative '../../app/presenters/patient_presenter'
require_relative '../../lib/age_calculator'

describe PatientPresenter do
  describe '#formatted_birthdate' do
    context 'when the patient is new' do
      it 'returns an empty string' do
        patient = double(:patient, new_record?: true)
        presenter = described_class.new(patient)
        expect(presenter.formatted_birthdate).to be_empty
      end
    end

    context 'when the patient already exists' do
      it 'returns a formatted date' do
        patient = double(:patient, new_record?: false,
                                   birthdate: Date.new(2017, 7, 12))
        presenter = described_class.new(patient)
        expect(presenter.formatted_birthdate).to eq('2017-07-12')
      end
    end
  end

  describe '#name' do
    it "returns patient's full name" do
      patient = double(:patient, first_name: 'Alice', last_name: 'Doe')
      presenter = described_class.new(patient)
      expect(presenter.name).to eq('Doe Alice')
    end
  end

  describe '#age' do
    context 'when the patient has a birthdate' do
      subject(:presenter) do
        patient = double(:patient, birthdate: Date.new(2011, 12, 8))
        described_class.new(patient)
      end

      it 'returns their age' do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(presenter.age.years).to eq(3)
        end
      end
    end

    context "when the patient doesn't have a birthdate" do
      subject(:presenter) do
        patient = double(:patient, birthdate: nil)
        described_class.new(patient)
      end

      it 'returns 0' do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(presenter.age.years).to eq(0)
        end
      end
    end
  end
end
