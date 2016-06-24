require 'rails_helper'

describe Disease do
  describe 'validations' do
    subject { Disease.new(code: 'A001', name: 'disease') }

    it { is_expected.to validate_uniqueness_of :code }
  end

  describe 'normalize attributes' do
    it 'upcases the attributes' do
      disease = Disease.create(code: 'A002', name: 'rhinitis')
      expect(disease.name).to eq('RHINITIS')
    end
  end
end
