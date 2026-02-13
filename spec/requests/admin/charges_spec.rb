require 'rails_helper'

RSpec.describe 'Admin::Charges', type: :request do
  before { login_as create(:user, admin: true), scope: :user }

  describe 'GET /admin/charges' do
    before { get admin_charges_path }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /admin/charges/export' do
    before do
      create(:consultation)
      get export_admin_charges_path
    end

    it 'returns an Excel file' do
      expect(response.content_type).to include('spreadsheetml')
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
