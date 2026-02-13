require 'rails_helper'

RSpec.describe 'API::PaymentChanges', type: :request do
  let(:doctor) { create(:user, doctor: true) }
  let(:consultation) do
    c = create(:consultation, doctor: doctor, payment: 50.00)
    c.current_user = doctor
    c
  end

  describe 'GET /api/consultations/:consultation_id/payment_changes' do
    before do
      login_as doctor, scope: :user
      consultation.payment_changes.create!(
        previous_payment: 50, updated_payment: 75,
        reason: 'test', type: :paid, user: doctor
      )
      get api_consultation_payment_changes_path(consultation,
                                                type: 'paid',
                                                format: :json)
    end

    it 'responds with json' do
      expect(response).to be_json
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /api/consultations/:consultation_id/payment_changes' do
    before { login_as doctor, scope: :user }

    let(:valid_params) do
      {
        change_payment: {
          previous_payment: 50, updated_payment: 100,
          reason: 'adjustment', type: :paid
        }
      }
    end

    context 'when the information is valid' do
      it 'creates a payment change' do
        expect do
          post api_consultation_payment_changes_path(
            consultation, format: :json
          ), params: valid_params
        end.to change(PaymentChange, :count).by(1)
      end

      it 'responds with success' do
        post api_consultation_payment_changes_path(
          consultation, format: :json
        ), params: valid_params

        expect(response).to be_json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the information is invalid' do
      it 'does not create a payment change' do
        expect do
          post api_consultation_payment_changes_path(
            consultation, format: :json
          ), params: {
            change_payment: {
              previous_payment: 50, updated_payment: 0,
              reason: '', type: :paid
            }
          }
        end.not_to change(PaymentChange, :count)
      end
    end
  end
end
