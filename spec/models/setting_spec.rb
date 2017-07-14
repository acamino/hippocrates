require 'rails_helper'

describe Setting do
  describe 'validations' do
    subject { Setting.new(name: 'maximum_diagnoses', value: '5') }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :value }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_numericality_of(:value).only_integer }
  end

  [
    Setting::MAXIMUM_DIAGNOSES,
    Setting::MAXIMUM_PRESCRIPTIONS,
    Setting::MEDICAL_HISTORY_SEQUENCE
  ].each do |setting_name|
    describe ".#{setting_name}" do
      subject { described_class.public_send(setting_name.to_sym) }

      context 'when the setting is present' do
        it 'returns the setting' do
          setting = described_class.create(name: setting_name, value: '2')
          expect(subject).to eq(setting)
        end
      end

      context 'when setting is not present' do
        it 'raises an error' do
          expect { subject }.to raise_error(SettingNotFoundError)
        end
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
