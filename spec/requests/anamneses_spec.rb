require 'rails_helper'

RSpec.describe 'Anamneses', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /patients/:patient_id/anamneses/new' do
    let(:patient) { create(:patient) }

    before { get new_patient_anamnesis_path(patient) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /patients/:patient_id/anamneses' do
    let(:patient) { create(:patient) }
    let(:attributes_for_anamnesis) { attributes_for(:anamnesis) }

    it 'creates a new anamnesis' do
      expect do
        post patient_anamneses_path(patient),
             params: { anamnesis: attributes_for_anamnesis }
      end.to change(Anamnesis, :count).by(1)
    end

    it 'redirects to new consultation' do
      post patient_anamneses_path(patient),
           params: { anamnesis: attributes_for_anamnesis }

      expect(response).to redirect_to(new_patient_consultation_path(patient))
    end
  end

  describe 'GET /patients/:patient_id/anamneses/:id/edit' do
    let(:patient) { create(:patient_with_anamnesis) }

    before do
      get edit_patient_anamnesis_path(patient, patient.anamnesis)
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PUT /patients/:patient_id/anamneses/:id' do
    let(:patient) { create(:patient_with_anamnesis) }

    before do
      put patient_anamnesis_path(patient, patient.anamnesis),
          params: { anamnesis: { family_history: 'family history updated' } }
    end

    it 'updates the anamnesis' do
      patient.reload
      expect(patient.anamnesis.family_history).to eq('FAMILY HISTORY UPDATED')
    end

    it { expect(response).to redirect_to(patients_path) }
  end
end
