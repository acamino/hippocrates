require 'timecop'
require_relative '../../app/presenters/patient_presenter'
require_relative '../../app/presenters/consultation_presenter'
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
    let(:presenter) do
      patient = double(:patient, birthdate: age)
      described_class.new(patient)
    end

    context 'when the patient has a birthdate' do
      let(:age) { Date.new(2011, 12, 8) }

      it 'returns their age' do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(presenter.age.years).to eq(3)
        end
      end
    end

    context "when the patient doesn't have a birthdate" do
      let(:age) { nil }

      it 'returns 0' do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(presenter.age.years).to eq(0)
        end
      end
    end
  end

  describe '#most_recent_consultation' do
    it 'returns the most recent consultation' do
      patient = double(
        :patient, consultations: double(most_recent: double)
      )
      presenter = described_class.new(patient)
      expect(presenter.most_recent_consultation).to be_a(ConsultationPresenter)
    end
  end

  describe '#anamnesis?' do
    context 'when anamnesis is present' do
      it 'returns true' do
        patient = double(:patient, anamnesis: 'extra notes')
        presenter = described_class.new(patient)
        expect(presenter.anamnesis?).to be_truthy
      end
    end

    context 'when anamnesis is not present' do
      it 'returns false' do
        patient = double(:patient, anamnesis: nil)
        presenter = described_class.new(patient)
        expect(presenter.anamnesis?).to be_falsey
      end
    end
  end

  describe '#consultations?' do
    context 'when consultations is present' do
      it 'returns true' do
        patient = double(:patient, consultations: 'extra notes')
        presenter = described_class.new(patient)
        expect(presenter.consultations?).to be_truthy
      end
    end

    context 'when consultations is not present' do
      it 'returns false' do
        patient = double(:patient, consultations: nil)
        presenter = described_class.new(patient)
        expect(presenter.consultations?).to be_falsey
      end
    end
  end
end
