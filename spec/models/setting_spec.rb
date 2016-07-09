require 'rails_helper'

describe Setting do
  describe 'validations' do
    subject { Setting.new(name: 'maximum_diagnoses', value: '5') }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :value }
    it { is_expected.to validate_uniqueness_of :name }
  end

  %w(maximum_diagnoses maximum_prescriptions).each do |setting_name|
    describe ".#{setting_name}" do
      it 'returns its value' do
        described_class.create(name: setting_name, value: '4')
        expect(described_class.send(setting_name)).to eq(4)
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
