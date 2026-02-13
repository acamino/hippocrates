require 'rails_helper'

RSpec.describe 'Admin::Activities', type: :request do
  before { login_as create(:user, admin: true), scope: :user }

  describe 'GET /admin/activities' do
    before { get admin_activities_path }

    it { expect(response).to have_http_status(:ok) }
  end
end
