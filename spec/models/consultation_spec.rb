require 'rails_helper'

describe Consultation do
  describe 'associations' do
    it { is_expected.to belong_to :patient }
    it { is_expected.to have_many(:diagnoses) }
    it { is_expected.to have_many(:prescriptions) }
  end

  describe 'prescription ordering' do
    let(:consultation) { create(:consultation) }

    it 'returns prescriptions ordered by position' do
      second = consultation.prescriptions.create!(
        inscription: 'Second', subscription: 'S2', position: 1
      )
      first = consultation.prescriptions.create!(
        inscription: 'First', subscription: 'S1', position: 0
      )

      expect(consultation.prescriptions.reload).to eq([first, second])
    end
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

    context 'when two consultations share the same created_at timestamp' do
      let(:collision_time) { 1.minute.ago }
      let(:collision_patient) { create(:patient) }
      let!(:first_consultation) do
        create(:consultation, patient: collision_patient, created_at: collision_time)
      end
      let!(:second_consultation) do
        create(:consultation, patient: collision_patient, created_at: collision_time)
      end

      it 'returns exactly one consultation (the one with the higher id)' do
        results = described_class.most_recent_by_patient
                                 .where(patient_id: collision_patient.id)
        expect(results.count).to eq(1)
        expect(results.first).to eq(second_consultation)
      end
    end

    context 'with multiple patients having multiple consultations' do
      let(:patient_b) { create(:patient) }
      let!(:patient_b_old) { create(:consultation, patient: patient_b, created_at: 2.hours.ago) }
      let!(:patient_b_new) { create(:consultation, patient: patient_b, created_at: 30.minutes.ago) }

      it 'returns exactly one consultation per patient' do
        results = described_class.most_recent_by_patient
        patient_ids = results.map(&:patient_id)
        expect(patient_ids).to match_array([patient.id, patient_b.id])
        expect(results.find { |c| c.patient_id == patient_b.id }).to eq(patient_b_new)
      end
    end

    context 'with a single consultation for a patient' do
      let(:solo_patient) { create(:patient) }
      let!(:solo_consultation) { create(:consultation, patient: solo_patient) }

      it 'returns that consultation' do
        results = described_class.most_recent_by_patient
                                 .where(patient_id: solo_patient.id)
        expect(results.to_a).to eq([solo_consultation])
      end
    end

    context 'when merged with .kept' do
      let(:discard_patient) { create(:patient) }
      let!(:discarded_consultation) do
        create(:consultation, patient: discard_patient, created_at: 2.hours.ago).tap(&:discard)
      end
      let!(:kept_consultation) do
        create(:consultation, patient: discard_patient, created_at: 1.minute.ago)
      end

      it 'returns the most recent kept consultation' do
        results = described_class.most_recent_by_patient.kept
                                 .where(patient_id: discard_patient.id)
        expect(results.to_a).to eq([kept_consultation])
      end
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

    context 'when special patients have timestamp collisions' do
      let(:collision_time) { 30.minutes.ago }
      let!(:bob_first_collision) do
        create(:consultation, patient: bob, created_at: collision_time)
      end
      let!(:bob_second_collision) do
        create(:consultation, patient: bob, created_at: collision_time)
      end

      it 'returns exactly one consultation per special patient' do
        results = described_class.most_recent_for_special_patients
        bob_results = results.select { |c| c.patient_id == bob.id }
        expect(bob_results.size).to eq(1)
        expect(bob_results.first).to eq(bob_second_collision)
      end
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
