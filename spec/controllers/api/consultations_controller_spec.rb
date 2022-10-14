require 'rails_helper'

describe API::ConsultationsController do
  before { sign_in_user_mock }

  let!(:bob) { create(:patient) }
  let!(:c1)  { create(:consultation, reason: 'bob-c1', patient: bob) }
  let!(:c2)  { create(:consultation, reason: 'bob-c2', patient: bob, next_appointment: nil) }

  describe '#show' do
    it 'returns the consultation' do
      post :show, params: { patient_id: bob.id, id: c1.id }
      json_response = ::JSON.parse(response.body)
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

  describe '#destroy' do
    let(:consultations) { "#{c1.id}_#{c2.id}" }

    before do |example|
      unless example.metadata[:skip_on_before]
        delete :destroy, params: { patient_id: bob.id,
                                   consultations: consultations }
      end
    end

    context 'when consultations are given' do
      it 'destroys consultations', :skip_on_before do
        expect do
          delete :destroy, params: { patient_id: bob.id, consultations: consultations }
          c1.reload
          c2.reload
        end.to(
          change(c1, :discarded?).from(false).to(true)
          .and(change(c2, :discarded?).from(false).to(true))
        )
      end
    end

    context 'when no consultations are given' do
      let(:consultations) { '' }

      it 'does not destroy consultations', :skip_on_before do
        expect do
          delete :destroy, params: { patient_id: bob.id, consultations: consultations }
        end.to change { Consultation.count }.by(0)
      end
    end

    it { is_expected.to respond_with :ok }

    it 'responds with json' do
      expect(response).to be_json
    end
  end
end
