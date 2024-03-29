require 'rails_helper'

describe Setting do
  describe 'validations' do
    subject { Setting.new(name: name, value: value) }

    let(:name)  { 'maximum_diagnoses' }
    let(:value) { '5' }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :value }
    it { is_expected.to validate_uniqueness_of :name }

    context 'when the setting is *NOT* an emergency number' do
      let(:name)  { 'maximum_prescriptions' }
      let(:value) { '5' }

      it { is_expected.to validate_numericality_of(:value).only_integer }
    end

    context 'when the setting is an emergency number' do
      let(:name)  { 'emergency_phone_number' }
      let(:value) { '099 555 5555' }

      it { is_expected.not_to validate_numericality_of(:value).only_integer }
    end
  end

  [
    Setting::EMERGENCY_NUMBER,
    Setting::MAXIMUM_DIAGNOSES,
    Setting::MAXIMUM_PRESCRIPTIONS,
    Setting::MEDICAL_HISTORY_SEQUENCE,
    Setting::WEBSITE
  ].each do |setting_name|
    describe ".#{setting_name}" do
      subject { described_class.public_send(setting_name.to_sym) }

      it 'returns the setting' do
        setting = described_class.create(name: setting_name, value: '2')
        expect(subject).to eq(setting)
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
