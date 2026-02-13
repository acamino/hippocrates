require 'rails_helper'

RSpec.describe 'Authorization', type: :request do
  let(:regular_user) { create(:user, admin: false, super_admin: false, doctor: false) }
  let(:doctor_user)  { create(:user, admin: false, super_admin: false, doctor: true) }
  let(:admin_user)   { create(:user, admin: true,  super_admin: false, doctor: false) }

  describe 'unauthenticated access' do
    it 'redirects HTML requests to login' do
      get root_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects admin routes to login' do
      get admin_users_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns 401 for API requests' do
      get api_settings_path(format: :json)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'inactive user login' do
    let(:inactive_user) { create(:user, active: false) }

    it 'signs out the user and redirects to login' do
      post user_session_path, params: {
        user: { email: inactive_user.email, password: 's3cret' }
      }

      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response.body).to include('Tu usuario está inactivo')
    end
  end

  describe 'admin namespace' do
    context 'when the user is not an admin' do
      before { login_as regular_user, scope: :user }

      it 'redirects from admin/users to root' do
        get admin_users_path

        expect(response).to redirect_to(root_path)
      end

      it 'redirects from admin/settings to root' do
        get admin_settings_path

        expect(response).to redirect_to(root_path)
      end

      it 'redirects from admin/activities to root' do
        get admin_activities_path

        expect(response).to redirect_to(root_path)
      end

      it 'redirects from admin/charges to root' do
        get admin_charges_path

        expect(response).to redirect_to(root_path)
      end

      it 'redirects from admin/charts to root' do
        get admin_charts_path

        expect(response).to redirect_to(root_path)
      end

      it 'redirects from admin/branch_offices to root' do
        get admin_branch_offices_path

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the user is an admin' do
      before { login_as admin_user, scope: :user }

      it 'allows access to admin/users' do
        get admin_users_path

        expect(response).to have_http_status(:ok)
      end

      it 'allows access to admin/settings' do
        get admin_settings_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'API::SettingsController' do
    let!(:setting) { create(:setting, value: '1') }

    context 'when the user is not an admin' do
      before { login_as regular_user, scope: :user }

      it 'allows reading settings' do
        get api_settings_path(format: :json)

        expect(response).to have_http_status(:ok)
      end

      it 'forbids updating settings' do
        patch api_setting_path(setting, format: :json), params: { value: '2' }

        expect(response).to have_http_status(:forbidden)
        expect(setting.reload.value).to eq('1')
      end
    end

    context 'when the user is an admin' do
      before { login_as admin_user, scope: :user }

      it 'allows updating settings' do
        patch api_setting_path(setting, format: :json), params: { value: '2' }

        expect(response).to have_http_status(:ok)
        expect(setting.reload.value).to eq('2')
      end
    end
  end

  describe 'API::PaymentChangesController' do
    let(:consultation) { create(:consultation) }

    context 'when the user has no doctor or admin role' do
      before { login_as regular_user, scope: :user }

      it 'allows reading payment changes' do
        get api_consultation_payment_changes_path(
          consultation, type: 'paid', format: :json
        )

        expect(response).to have_http_status(:ok)
      end

      it 'forbids creating payment changes' do
        post api_consultation_payment_changes_path(consultation, format: :json),
          params: {
            change_payment: {
              previous_payment: 50, updated_payment: 75,
              reason: 'test', type: :paid
            }
          }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is a doctor' do
      before { login_as doctor_user, scope: :user }

      it 'allows creating payment changes' do
        post api_consultation_payment_changes_path(consultation, format: :json),
          params: {
            change_payment: {
              previous_payment: 50, updated_payment: 75,
              reason: 'test', type: :paid
            }
          }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user is an admin' do
      before { login_as admin_user, scope: :user }

      it 'allows creating payment changes' do
        post api_consultation_payment_changes_path(consultation, format: :json),
          params: {
            change_payment: {
              previous_payment: 50, updated_payment: 75,
              reason: 'test', type: :paid
            }
          }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
