require 'rails_helper'

RSpec.describe 'Admin::Settings', type: :request do
  before { login_as create(:user, admin: true), scope: :user }

  describe 'GET /admin/settings' do
    before do
      create(:setting, :maximum_diagnoses)
      create(:setting, :maximum_prescriptions)
      create(:setting, :medical_history_sequence)
      create(:setting, :emergency_number)
      get admin_settings_path
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
