require 'rails_helper'

describe Consultation do
  describe 'associations' do
    it { is_expected.to belong_to :patient }
    it { is_expected.to have_many(:diagnoses) }
    it { is_expected.to have_many(:prescriptions) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:diagnoses).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:prescriptions).allow_destroy(true) }
  end

  describe 'normalize attributes' do
    it 'upcases the attributes' do
      consultation = create(:consultation, reason: 'reason razón')
      expect(consultation.reload.reason).to eq('REASON RAZÓN')
    end
  end

  describe '.most_recent' do
    let!(:old_consultation)    { create :consultation, created_at: 1.hour.ago }
    let!(:recent_consultation) { create :consultation, created_at: Time.now }

    it 'returns the most recent consultation' do
      expect(Consultation.most_recent).to eq(recent_consultation)
    end
  end

  describe '#miscellaneous?' do
    let(:consultation) { build(:consultation) }

    context 'when miscellaneous is present' do
      it 'returns true' do
        consultation.miscellaneous = 'notes'
        expect(consultation.miscellaneous?).to be_truthy
      end
    end

    context 'when miscellaneous is not present' do
      it 'returns false' do
        expect(consultation.miscellaneous?).to be_falsey
      end
    end
  end
end
