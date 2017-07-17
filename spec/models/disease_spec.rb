require 'rails_helper'

describe Disease do
  describe 'validations' do
    subject { build(:disease) }

    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :code }
  end

  describe 'normalize attributes' do
    it 'upcases the attributes' do
      disease = create(:disease, name: 'rhinitis')
      expect(disease.name).to eq('RHINITIS')
    end
  end
end
