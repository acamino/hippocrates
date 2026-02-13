require 'rails_helper'

RSpec.describe 'API::Consultations', type: :request do
  before { login_as create(:user), scope: :user }

  let!(:bob) { create(:patient) }
  let!(:c1)  { create(:consultation, reason: 'bob-c1', patient: bob) }
  let!(:c2) do
    create(:consultation, reason: 'bob-c2', patient: bob,
                          next_appointment: nil)
  end

  describe 'GET /api/patients/:patient_id/consultations/:id' do
    it 'returns the consultation' do
      get api_patient_consultation_path(bob, c1, format: :json)

      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'consultation' => hash_including(
          'reason' => c1.reason
        ),
        'meta' => hash_including(
          'total' => 2
        )
      )
    end
  end

  describe 'DELETE /api/patients/:patient_id/consultations' do
    let(:consultations) { "#{c1.id}_#{c2.id}" }

    context 'when consultations are given' do
      it 'destroys consultations' do
        expect do
          delete api_patient_consultations_path(bob, format: :json),
                 params: { consultations: consultations }
          c1.reload
          c2.reload
        end.to(
          change(c1, :discarded?).from(false).to(true)
          .and(change(c2, :discarded?).from(false).to(true))
        )
      end
    end

    context 'when no consultations are given' do
      it 'does not destroy consultations' do
        expect do
          delete api_patient_consultations_path(bob, format: :json),
                 params: { consultations: '' }
        end.not_to change(Consultation, :count)
      end
    end

    it 'responds with json' do
      delete api_patient_consultations_path(bob, format: :json),
             params: { consultations: consultations }

      expect(response).to have_http_status(:ok)
      expect(response).to be_json
    end
  end
end
