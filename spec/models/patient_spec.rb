require 'rails_helper'

describe Patient do
  describe 'validations' do
    subject { build(:patient) }

    it { is_expected.to validate_presence_of :medical_history }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :identity_card_number }
    it { is_expected.to validate_presence_of :birthdate }
    it { is_expected.to validate_presence_of :gender }
    it { is_expected.to validate_presence_of :civil_status }
    it { is_expected.to validate_presence_of :source }

    it { is_expected.to validate_uniqueness_of :identity_card_number }
    it { is_expected.to validate_uniqueness_of :medical_history }
  end

  describe 'associations' do
    it { is_expected.to have_one(:anamnesis) }
    it { is_expected.to have_many(:consultations) }
  end

  describe 'normalize attributes' do
    it 'normalizes the attributes' do
      patient = create(:patient, first_name: 'bob', email: 'bob@example.com')
      expect(patient.reload.first_name).to eq('BOB')
      expect(patient.email).to eq('bob@example.com')
    end
  end

  describe '.search' do
    let!(:john_domino) { create(:patient, first_name: 'John', last_name: 'Domino') }
    let!(:mark_lopez)  { create(:patient, first_name: 'Mark', last_name: 'López') }
    let!(:john_carter) { create(:patient, first_name: 'John', last_name: 'Carter') }

    context 'when last name and first name are empty' do
      it 'returns all patients' do
        patients = described_class.search('', '')
        expect(patients).to eq([john_carter, john_domino, mark_lopez])
      end
    end

    context "when last name matches with some patient's last name" do
      it 'returns patients found' do
        patients = described_class.search('lópez', '')
        expect(patients).to eq([mark_lopez])
      end
    end

    context "when first name matches with some patient's first name" do
      it 'returns patients found' do
        patients = described_class.search('', 'john')
        expect(patients).to eq([john_carter, john_domino])
      end
    end

    context "when first name and last name matches with some patient's name" do
      it 'returns patients found' do
        patients = described_class.search('carter', 'john')
        expect(patients).to eq([john_carter])
      end
    end

    context 'when first name and last name does not match with any patient' do
      it 'returns an empty array' do
        patients = described_class.search('lopez', 'john')
        expect(patients).to eq([])
      end
    end
  end

  describe '#age' do
    context 'when a patient has a birthdate' do
      subject { build(:patient, birthdate: Date.new(2011, 12, 8)) }

      it "calculates patient's age" do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(subject.age).to eq(3)
        end
      end
    end

    context "when a patient doesn't have a birthdate" do
      subject { Patient.new }

      it 'returns 0' do
        Timecop.freeze(Date.new(2015, 10, 21)) do
          expect(subject.age).to eq(0)
        end
      end
    end
  end

  describe '#name' do
    it "returns patient's full name" do
      patient = build(:patient, first_name: 'Alice', last_name: 'Doe')
      expect(patient.name).to eq('Doe Alice')
    end
  end

  describe '#anamnesis?' do
    let(:patient) { build(:patient) }

    context 'when anamnesis is present' do
      it 'returns true' do
        patient.anamnesis = Anamnesis.new
        expect(patient.anamnesis?).to be_truthy
      end
    end

    context 'when anamnesis is not present' do
      it 'returns false' do
        expect(patient.anamnesis?).to be_falsey
      end
    end
  end

  describe '#consultations?' do
    let(:patient) { build(:patient) }

    context 'when consultations are present' do
      it 'returns true' do
        patient.consultations << Consultation.new
        expect(patient.consultations?).to be_truthy
      end
    end

    context 'when consultations are not present' do
      it 'returns false' do
        expect(patient.consultations?).to be_falsey
      end
    end
  end
end
