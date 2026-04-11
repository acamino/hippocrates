require 'rails_helper'

RSpec.describe 'API::Patients', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /api/patients' do
    context 'when there are patients who match the criteria' do
      let!(:alan) { create(:patient, last_name: 'Doe') }
      let!(:marc) { create(:patient, last_name: 'Doe') }

      before do
        get api_patients_path(format: :json), params: { query: 'Doe' }
      end

      it 'formats the response as JSON' do
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'suggestions' => [
            hash_including(
              'data'  => alan.id,
              'value' => alan.full_name
            ),
            hash_including(
              'data'  => marc.id,
              'value' => marc.full_name
            )
          ]
        )
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when there are *NO* patients who match the criteria' do
      before do
        create_list(:patient, 2, last_name: 'Doe')
        get api_patients_path(format: :json), params: { query: 'Ada' }
      end

      it 'formats the response as JSON' do
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'suggestions' => []
        )
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'PATCH /api/patients/:id' do
    let(:patient) { create(:patient) }

    it 'updates an editable field' do
      patch api_patient_path(patient, format: :json),
            params: { name: 'phone_number', value: '099999999' }

      expect(response).to have_http_status(:ok)
      expect(patient.reload.phone_number).to eq('099999999')
    end

    it 'rejects non-editable fields' do
      patch api_patient_path(patient, format: :json),
            params: { name: 'medical_history', value: '999' }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/patients/:id/consent' do
    let(:patient) { create(:patient, data_management_consent: false) }

    it 'grants consent' do
      patch consent_api_patient_path(patient, format: :json),
            params: { consent: true }

      expect(response).to have_http_status(:ok)
      expect(patient.reload.data_management_consent).to be true
    end

    it 'revokes consent' do
      patient.update!(data_management_consent: true)

      patch consent_api_patient_path(patient, format: :json),
            params: { consent: false }

      expect(response).to have_http_status(:ok)
      expect(patient.reload.data_management_consent).to be false
    end

    it 'returns consent status in response' do
      patch consent_api_patient_path(patient, format: :json),
            params: { consent: true }

      json_response = JSON.parse(response.body)
      expect(json_response).to eq('consent' => true)
    end
  end
end
