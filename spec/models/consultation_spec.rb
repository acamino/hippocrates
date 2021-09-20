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

  describe '.most_recent_by_patient' do
    let(:patient)              { (create :patient) }
    let!(:old_consultation)    { (create :consultation, patient: patient, created_at: 1.hour.ago) }
    let!(:recent_consultation) do
      (create :consultation, patient: patient, created_at: 1.minute.ago)
    end

    it 'returns the most recent consultation' do
      most_recent_consultations = described_class.most_recent_by_patient
      expect(most_recent_consultations.count).to eq(1)
      expect(most_recent_consultations.first).to eq(recent_consultation)
    end
  end

  describe '.most_recent_for_special_patients' do
    let!(:bob)                     { create(:patient, special: true) }
    let!(:tom)                     { create(:patient, special: true) }
    let!(:bob_old_consultation)    { create(:consultation, patient: bob, created_at: 1.day.ago) }
    let!(:bob_recent_consultation) { create(:consultation, patient: bob, created_at: 1.hour.ago) }
    let!(:tom_old_consultation)    { create(:consultation, patient: tom, created_at: 1.month.ago) }
    let!(:tom_recent_consultation) { create(:consultation, patient: tom, created_at: 1.day.ago) }

    before do
      regular = create(:patient, first_name: 'Regular')
      create(:consultation, patient: regular, created_at: 1.minute.ago)
    end

    it 'returns the most recent consultations for special patients' do
      expect(described_class.most_recent_for_special_patients).to eq(
        [
          bob_recent_consultation,
          tom_recent_consultation
        ]
      )
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
