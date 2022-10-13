require 'active_support/core_ext/object'
require 'delegate'
require 'timecop'

require_relative '../../app/presenters/consultation_presenter'
require_relative '../../app/presenters/patient_presenter'
require_relative '../../app/services/patients/age'

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

  describe '#medical_history' do
    it 'returns the formatted medical history' do
      patient = double(:patient)
      allow(patient).to receive(:[]).with(:medical_history).and_return('6723')

      presenter = described_class.new(patient)
      expect(presenter.medical_history).to eq('006723')
    end
  end

  describe '#identity_card_number' do
    it 'returns the formatted identity card number' do
      patient = double(:patient)
      allow(patient).to receive(:[]).with(:identity_card_number).and_return('6723')

      presenter = described_class.new(patient)
      expect(presenter.identity_card_number).to eq('0000006723')
    end
  end

  describe '#hearing_aids_es' do
    context 'when there hearing ads is true' do
      it 'returns *SI*' do
        patient = double(:patient, anamnesis: double(:anamnesis, hearing_aids: true))

        presenter = described_class.new(patient)
        expect(presenter.hearing_aids_es).to eq('SI')
      end
    end

    context 'when there hearing ads is false' do
      it 'returns *NO*' do
        patient = double(:patient, anamnesis: double(:anamnesis, hearing_aids: false))

        presenter = described_class.new(patient)
        expect(presenter.hearing_aids_es).to eq('NO')
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

  describe '#relative_age' do
    context 'when a consultation date is set' do
      let(:presenter) do
        patient = double(:patient, birthdate: Date.new(2011, 12, 8))
        presenter = described_class.new(patient)
        presenter.consultation_date = Date.new(2020, 10, 28)
        presenter
      end

      it 'calculates the age relative to the consultation date' do
        expect(presenter.relative_age.years).to eq(8)
        expect(presenter.relative_age.months).to eq(10)
      end
    end

    context 'when a consultation date is *NOT* set' do
      let(:presenter) do
        patient = double(:patient, birthdate: Date.new(2011, 12, 8))
        described_class.new(patient)
      end

      it 'calculates the age relative to the current date' do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(presenter.relative_age.years).to eq(3)
          expect(presenter.relative_age.months).to eq(10)
        end
      end
    end
  end

  describe '#gender_es' do
    context 'when the patient is male' do
      it 'returns the gender' do
        patient = double(:patient, male?: true)
        presenter = described_class.new(patient)
        expect(presenter.gender_es).to eq('Masculino')
      end
    end

    context 'when the patient is female' do
      it 'returns the gender' do
        patient = double(:patient, male?: false)
        presenter = described_class.new(patient)
        expect(presenter.gender_es).to eq('Femenino')
      end
    end
  end

  shared_examples 'translated civil status' do |civil_status_en, civil_status_es|
    context "when the patient is #{civil_status_en}" do
      let(:civil_status) { civil_status_en }

      it "returns #{civil_status_es}" do
        presenter = described_class.new(patient)
        expect(presenter.civil_status_es).to eq(civil_status_es)
      end
    end
  end

  describe '#civil_status_es' do
    let(:patient) { double(:patient, male?: male, civil_status: civil_status) }
    context 'when the patient is male' do
      let(:male) { true }

      it_behaves_like 'translated civil status', 'single',      'SOLTERO'
      it_behaves_like 'translated civil status', 'married',     'CASADO'
      it_behaves_like 'translated civil status', 'civil_union', 'UNIÓN LIBRE'
      it_behaves_like 'translated civil status', 'divorced',    'DIVORCIADO'
      it_behaves_like 'translated civil status', 'widowed',     'VIUDO'
    end

    context 'when the patient is female' do
      let(:male) { false }

      it_behaves_like 'translated civil status', 'single',      'SOLTERA'
      it_behaves_like 'translated civil status', 'married',     'CASADA'
      it_behaves_like 'translated civil status', 'civil_union', 'UNIÓN LIBRE'
      it_behaves_like 'translated civil status', 'divorced',    'DIVORCIADA'
      it_behaves_like 'translated civil status', 'widowed',     'VIUDA'
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
