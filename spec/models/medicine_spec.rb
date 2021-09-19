require 'rails_helper'

describe Medicine do
  describe 'validations' do
    subject { Medicine.new(name: 'name', instructions: 'instructions') }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :instructions }

    it { is_expected.to validate_uniqueness_of :name }
  end

  describe 'normalize attributes' do
    it 'upcases the attributes' do
      medicine = create(:medicine, name: ' penicillin  ')
      expect(medicine.reload.name).to eq('PENICILLIN')
    end
  end
end
