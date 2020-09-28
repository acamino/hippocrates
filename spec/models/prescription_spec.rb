require 'rails_helper'

describe Prescription do
  describe 'validations' do
    it { is_expected.to validate_presence_of :inscription }
    it { is_expected.to validate_presence_of :subscription }
  end

  describe 'associations' do
    it { is_expected.to belong_to :consultation }
  end

  describe 'normalize attributes' do
    it 'upcases the attributes' do
      consultation = create(:prescription, inscription: 'Inscription', subscription: 'Subscription')
      expect(consultation.reload.inscription).to eq('INSCRIPTION')
      expect(consultation.reload.subscription).to eq('SUBSCRIPTION')
    end
  end
end
