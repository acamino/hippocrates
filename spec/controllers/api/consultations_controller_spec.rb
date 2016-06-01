require 'rails_helper'

describe API::ConsultationsController do
  let!(:bob) { create(:patient) }
  let!(:c1)  { create(:consultation, reason: 'bob-c1', patient: bob) }
  let!(:c2)  { create(:consultation, reason: 'bob-c2', patient: bob) }

  describe '#last' do
    it 'returns the last consultation' do
      post :last, patient_id: bob.id
      consultation = ::JSON.parse(response.body)
      expect(consultation['reason']).to eq(c2.reason)
    end
  end

  describe '#previous' do
    it 'returns the previous consultation' do
      post :previous, patient_id: bob.id, current_consultation: c2.id
      consultation = ::JSON.parse(response.body)
      expect(consultation['reason']).to eq(c1.reason)
    end
  end

  describe '#next' do
    it 'returns the next consultation' do
      post :next, patient_id: bob.id, current_consultation: c1.id
      consultation = ::JSON.parse(response.body)
      expect(consultation['reason']).to eq(c2.reason)
    end
  end
end
