require 'rails_helper'

RSpec.describe 'API::Users', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /api/users' do
    let!(:alice) { create(:user, pretty_name: 'Dr. Alice') }
    let!(:bob)   { create(:user, pretty_name: 'Dr. Bob') }

    it 'returns matching users as suggestions' do
      get api_users_path(format: :json), params: { query: 'Alice' }

      json = JSON.parse(response.body)
      values = json['suggestions'].map { |s| s['value'] }
      expect(values).to include('DR. ALICE')
    end

    it 'limits results to 40' do
      get api_users_path(format: :json), params: { query: '' }

      json = JSON.parse(response.body)
      expect(json['suggestions'].size).to be <= 40
    end

    it 'responds with json' do
      get api_users_path(format: :json), params: { query: 'Alice' }

      expect(response).to have_http_status(:ok)
      expect(response).to be_json
    end
  end
end
