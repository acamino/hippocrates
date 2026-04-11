require 'rails_helper'

RSpec.describe 'API::Anamneses', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'PATCH /api/anamneses/:id' do
    let(:patient) { create(:patient_with_anamnesis) }
    let(:anamnesis) { patient.anamnesis }

    it 'updates a text field' do
      patch api_anamnesis_path(anamnesis, format: :json),
            params: { name: 'allergies', value: 'Penicillin' }

      expect(response).to have_http_status(:ok)
      expect(anamnesis.reload.allergies).to eq('PENICILLIN')
    end

    it 'updates the hearing_aids field' do
      patch api_anamnesis_path(anamnesis, format: :json),
            params: { name: 'hearing_aids', value: 'true' }

      expect(response).to have_http_status(:ok)
    end

    it 'updates family_history' do
      patch api_anamnesis_path(anamnesis, format: :json),
            params: { name: 'family_history', value: 'Diabetes' }

      expect(response).to have_http_status(:ok)
      expect(anamnesis.reload.family_history).to eq('DIABETES')
    end

    it 'rejects non-editable fields' do
      patch api_anamnesis_path(anamnesis, format: :json),
            params: { name: 'patient_id', value: '999' }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns the updated value' do
      patch api_anamnesis_path(anamnesis, format: :json),
            params: { name: 'observations', value: 'new observation' }

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('value' => 'new observation')
    end
  end
end
