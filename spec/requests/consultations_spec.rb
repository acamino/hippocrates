require 'rails_helper'

RSpec.describe 'Consultations', type: :request do
  let(:doctor) { create(:user, doctor: true) }

  before do
    create(:setting, :maximum_diagnoses)
    create(:setting, :maximum_prescriptions)
    login_as doctor, scope: :user
  end

  describe 'GET /patients/:patient_id/consultations' do
    let(:patient) { create(:patient_with_anamnesis, :with_consultations) }

    before { get patient_consultations_path(patient) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /patients/:patient_id/consultations/new' do
    let(:patient) { create(:patient_with_anamnesis, :with_consultations) }

    before { get new_patient_consultation_path(patient) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /patients/:patient_id/consultations' do
    let(:patient) { create(:patient) }
    let(:attributes_for_consultation) do
      attributes_for(:consultation).merge(
        patient: { special: 'true' },
        user_id: doctor.id,
        payment: 10.0
      )
    end

    it 'creates a new consultation' do
      expect do
        post patient_consultations_path(patient),
             params: { consultation: attributes_for_consultation }
      end.to change(Consultation, :count).by(1)
    end

    it 'creates new diagnoses' do
      pharyngitis = Disease.create(code: 'A001', name: 'Pharyngitis')
      rhinitis    = Disease.create(code: 'A002', name: 'Rhinitis')

      post patient_consultations_path(patient),
           params: {
             consultation: attributes_for_consultation.merge(
               diagnoses_attributes: {
                 '0' => {
                   disease_code: pharyngitis.code,
                   description: pharyngitis.name,
                   type: 'presuntive'
                 },
                 '1' => {
                   disease_code: rhinitis.code,
                   description: rhinitis.name,
                   type: 'presuntive'
                 }
               }
             )
           }

      expect(patient.consultations.last.diagnoses.count).to eq(2)
    end

    it 'creates new prescriptions' do
      post patient_consultations_path(patient),
           params: {
             consultation: attributes_for_consultation.merge(
               prescriptions_attributes: {
                 '0' => { inscription: 'i1', subscription: 's1' },
                 '1' => { inscription: 'i2', subscription: 's2' }
               }
             )
           }

      expect(patient.consultations.last.prescriptions.count).to eq(2)
    end

    it "updates patient's special field" do
      expect do
        post patient_consultations_path(patient),
             params: { consultation: attributes_for_consultation }
        patient.reload
      end.to change { patient.special }.from(false).to(true)
    end

    it 'redirects to edit consultation' do
      post patient_consultations_path(patient),
           params: { consultation: attributes_for_consultation }

      expect(response).to redirect_to(
        edit_patient_consultation_path(patient, patient.most_recent_consultation)
      )
    end
  end

  describe 'GET /patients/:patient_id/consultations/:id/edit' do
    let!(:patient) { create(:patient_with_anamnesis) }
    let!(:consultation) { create(:consultation, patient: patient) }

    before do
      get edit_patient_consultation_path(patient, consultation)
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PATCH /patients/:patient_id/consultations/:id' do
    let!(:patient) { create(:patient) }
    let!(:consultation) do
      create(:consultation, patient: patient, created_at: '2020-10-16 18:01:00')
    end

    before do
      patch patient_consultation_path(patient, consultation),
            params: {
              consultation: {
                reason: 'updated reason',
                hearing_aids: 'updated hearing aids',
                created_at: '2020-10-14',
                patient: { special: false },
                payment: 10.0
              }
            }
    end

    it 'updates consultation' do
      consultation.reload
      expect(consultation.reason).to eq('UPDATED REASON')
      expect(consultation.hearing_aids).to eq('UPDATED HEARING AIDS')
      expect(consultation.created_at).to eq('Wed, 14 Oct 2020 18:01:00 -05 -05:00')
    end

    it do
      expect(response).to redirect_to(
        edit_patient_consultation_path(patient, consultation)
      )
    end
  end
end
