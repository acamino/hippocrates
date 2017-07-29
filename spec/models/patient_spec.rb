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
        patients = described_class.search('lÓpez', '')
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
end
