require 'rails_helper'

describe API::ConsultationsController do
  before { sign_in_user_mock }

  let!(:bob) { create(:patient) }
  let!(:c1)  { create(:consultation, reason: 'bob-c1', patient: bob) }
  let!(:c2)  { create(:consultation, reason: 'bob-c2', patient: bob, next_appointment: nil) }

  describe '#last' do
    it 'returns the last consultation' do
      post :last, params: { patient_id: bob.id }
      consultation = ::JSON.parse(response.body)
      expect(consultation['reason']).to eq(c2.reason)
    end
  end

  describe '#previous' do
    context 'when there is a previous consultation' do
      it 'returns the previous consultation' do
        post :previous, params: { patient_id: bob.id, current_consultation: c2.id }
        consultation = ::JSON.parse(response.body)
        expect(consultation['reason']).to eq(c1.reason)
      end
    end

    context 'when there is a previous consultation' do
      before do
        post :previous, params: { patient_id: bob.id, current_consultation: c1.id }
      end

      it 'responds with not found' do
        expect(response).to be_not_found
      end

      it 'responds with json' do
        expect(response).to be_json
      end
    end
  end

  describe '#next' do
    it 'returns the next consultation' do
      post :next, params: { patient_id: bob.id, current_consultation: c1.id }
      consultation = ::JSON.parse(response.body)
      expect(consultation['reason']).to eq(c2.reason)
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
