require 'rails_helper'

RSpec.describe 'API::Settings', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /api/settings' do
    before do
      create(:setting, name: 'name-1', value: '1')
      get api_settings_path(format: :json)
    end

    it 'responds with json' do
      expect(response).to be_json
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PATCH /api/settings/:id' do
    let!(:setting) { create(:setting, value: '1') }

    before do
      login_as create(:user, admin: true), scope: :user
    end

    context 'when the information is valid' do
      before do
        patch api_setting_path(setting, format: :json),
              params: { value: '2' }
      end

      it 'updates setting' do
        expect(setting.reload.value).to eq('2')
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when the information is invalid' do
      before do
        patch api_setting_path(setting, format: :json),
              params: { value: '' }
      end

      it 'does not update the setting' do
        expect(setting.reload.value).to eq('1')
      end

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end
end
