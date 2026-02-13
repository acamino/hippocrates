require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  before { login_as create(:user, admin: true), scope: :user }

  describe 'GET /admin/users' do
    before do
      create(:user)
      get admin_users_path
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /admin/users/new' do
    before { get new_admin_user_path }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /admin/users' do
    context 'when the information is valid' do
      let(:user_params) do
        {
          email: 'new@example.com',
          pretty_name: 'Dr. New',
          registration_acess: 'R999',
          password: 's3cret'
        }
      end

      it 'creates a user' do
        expect do
          post admin_users_path, params: { user: user_params }
        end.to change(User, :count).by(1)
      end

      it 'redirects to admin users' do
        post admin_users_path, params: { user: user_params }
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'when the information is invalid' do
      it 'does not create a user' do
        expect do
          post admin_users_path, params: { user: { email: '' } }
        end.not_to change(User, :count)
      end

      it 're-renders new' do
        post admin_users_path, params: { user: { email: '' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /admin/users/:id/edit' do
    let(:user) { create(:user) }

    before { get edit_admin_user_path(user) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PUT /admin/users/:id' do
    let(:user) { create(:user, pretty_name: 'Dr. Old') }

    context 'when the information is valid' do
      before do
        put admin_user_path(user),
            params: { user: { pretty_name: 'Dr. New' } }
      end

      it 'updates the user' do
        expect(user.reload.pretty_name).to eq('Dr. New')
      end

      it { expect(response).to redirect_to(admin_users_path) }
    end

    context 'when updating without password' do
      it 'uses update_without_password' do
        put admin_user_path(user),
            params: { user: { pretty_name: 'Dr. Changed' } }

        expect(user.reload.pretty_name).to eq('Dr. Changed')
      end
    end

    context 'when the information is invalid' do
      before do
        put admin_user_path(user), params: { user: { email: '' } }
      end

      it 'does not update the user' do
        expect(user.reload.pretty_name).to eq('Dr. Old')
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
