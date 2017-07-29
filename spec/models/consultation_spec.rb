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
      expect(described_class.most_recent).to eq(recent_consultation)
    end
  end

  describe 'override getters' do
    context 'when the attribute has a value' do
      it 'returns the same value' do
        consultation = build(:consultation, right_ear: 'RIGHT EAR')
        expect(consultation.right_ear).to eq('RIGHT EAR')
      end
    end

    context 'when the attribute is empty' do
      it 'returns the NORMAL' do
        consultation = build(:consultation, right_ear: '')
        expect(consultation.right_ear).to eq('NORMAL')
      end
    end
  end
end
