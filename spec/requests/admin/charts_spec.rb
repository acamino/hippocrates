require 'rails_helper'

RSpec.describe 'Admin::Charts', type: :request do
  before { login_as create(:user, admin: true), scope: :user }

  describe 'GET /admin/charts' do
    before { get admin_charts_path }

    it { expect(response).to have_http_status(:ok) }
  end
end
