require 'rails_helper'

describe API::PaymentChangesController do
  let(:doctor) { create(:user, doctor: true) }
  let(:consultation) do
    c = create(:consultation, doctor: doctor, payment: 50.00)
    c.current_user = doctor
    c
  end

  describe '#index' do
    before do
      sign_in_user_mock(doctor?: true)
      consultation.payment_changes.create!(
        previous_payment: 50, updated_payment: 75,
        reason: 'test', type: :paid, user: doctor
      )
      get :index, params: { consultation_id: consultation.id, type: 'paid' }, format: :json
    end

    it 'responds with json' do
      expect(response).to be_json
    end

    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    before do
      sign_in_user_mock(doctor?: true, id: doctor.id)
    end

    let(:valid_params) do
      {
        consultation_id: consultation.id,
        change_payment: {
          previous_payment: 50, updated_payment: 100,
          reason: 'adjustment', type: :paid
        },
        format: :json
      }
    end

    context 'when the information is valid' do
      it 'creates a payment change' do
        expect {
          post :create, params: valid_params
        }.to change(PaymentChange, :count).by(1)
      end

      it 'responds with success' do
        post :create, params: valid_params

        expect(response).to be_json
        is_expected.to respond_with :ok
      end
    end

    context 'when the information is invalid' do
      it 'does not create a payment change' do
        expect {
          post :create, params: {
            consultation_id: consultation.id,
            change_payment: { previous_payment: 50, updated_payment: 0,
                              reason: '', type: :paid },
            format: :json
          }
        }.not_to change(PaymentChange, :count)
      end
    end
  end
end
