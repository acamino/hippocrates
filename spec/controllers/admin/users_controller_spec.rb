require 'rails_helper'

describe Admin::UsersController do
  before { sign_in_user_mock(admin_or_super_admin?: true) }

  describe '#index' do
    before do
      create(:user)
      get :index
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    before { get :new }

    it 'assigns @user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
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
        expect {
          post :create, params: { user: user_params }
        }.to change(User, :count).by(1)
      end

      it 'redirects to admin users' do
        post :create, params: { user: user_params }

        is_expected.to redirect_to admin_users_path
      end
    end

    context 'when the information is invalid' do
      it 'does not create a user' do
        expect {
          post :create, params: { user: { email: '' } }
        }.not_to change(User, :count)
      end

      it 'renders new' do
        post :create, params: { user: { email: '' } }

        is_expected.to render_template :new
      end
    end
  end

  describe '#edit' do
    let(:user) { create(:user) }

    before { get :edit, params: { id: user.id } }

    it 'assigns @user' do
      expect(assigns(:user)).to eq(user)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let(:user) { create(:user, pretty_name: 'Dr. Old') }

    context 'when the information is valid' do
      before do
        put :update, params: { id: user.id, user: { pretty_name: 'Dr. New' } }
      end

      it 'updates the user' do
        expect(user.reload.pretty_name).to eq('Dr. New')
      end

      it { is_expected.to redirect_to admin_users_path }
    end

    context 'when updating without password' do
      it 'uses update_without_password' do
        put :update, params: { id: user.id, user: { pretty_name: 'Dr. Changed' } }

        expect(user.reload.pretty_name).to eq('Dr. Changed')
      end
    end

    context 'when the information is invalid' do
      before do
        put :update, params: { id: user.id, user: { email: '' } }
      end

      it 'does not update the user' do
        expect(user.reload.pretty_name).to eq('Dr. Old')
      end

      it { is_expected.to render_template :edit }
    end
  end
end
