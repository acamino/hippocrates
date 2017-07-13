require 'rails_helper'

describe Setting do
  describe 'validations' do
    subject { Setting.new(name: 'maximum_diagnoses', value: '5') }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :value }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_numericality_of(:value).only_integer }
  end

  describe '.maximum_diagnoses' do
    context 'when setting is present' do
      it 'returns maximum diagnoses value' do
        described_class.create(name: Setting::MAXIMUM_DIAGNOSES, value: '4')
        expect(described_class.maximum_diagnoses).to eq(4)
      end
    end

    context 'when setting is not present' do
      it 'raises an error' do
        expect do
          described_class.maximum_diagnoses
        end.to raise_error(SettingNotFoundError)
      end
    end
  end

  describe '.maximum_prescriptions' do
    context 'when setting is present' do
      it 'returns maximum prescriptions value' do
        described_class.create(name: Setting::MAXIMUM_PRESCRIPTIONS, value: '5')
        expect(described_class.maximum_prescriptions).to eq(5)
      end
    end

    context 'when setting is not present' do
      it 'raises an error' do
        expect do
          described_class.maximum_prescriptions
        end.to raise_error(SettingNotFoundError)
      end
    end
  end

  describe '::MedicalHistorySequence' do
    describe '.next' do
      it 'returns the next value for the sequence' do
        create(:setting, :medical_history_sequence, value: '4')
        expect(described_class::MedicalHistorySequence.next).to eq(5)
      end
    end

    describe '#save' do
      it 'computes the next value in the sequence and save it' do
        setting = create(:setting, :medical_history_sequence, value: '4')
        Setting::MedicalHistorySequence.new.save

        expect(setting.reload.value).to eq('5')
      end
    end
  end
end
