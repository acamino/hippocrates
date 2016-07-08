require 'rails_helper'

describe Setting do
  describe 'validations' do
    subject { Setting.new(name: 'maximum_diagnoses', value: '5') }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :value }
    it { is_expected.to validate_uniqueness_of :name }
  end

  ['maximum_diagnoses', 'maximum_prescriptions'].each do |setting_name|
    describe ".#{setting_name}" do
      it "returns its value" do
        described_class.create(name: setting_name, value: '4')
        expect(described_class.send(setting_name)).to eq(4)
      end
    end
  end
end
