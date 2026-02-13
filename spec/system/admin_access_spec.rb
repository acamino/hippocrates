require 'rails_helper'

RSpec.describe 'Admin access', type: :system do
  describe 'admin can access settings' do
    let(:admin_user) { create(:user, active: true, admin: true) }

    before { login_as admin_user, scope: :user }

    it 'shows the settings page' do
      visit admin_settings_path

      expect(page).to have_http_status(:ok)
    end
  end

  describe 'non-admin blocked from admin namespace' do
    let(:regular_user) { create(:user, active: true, admin: false, super_admin: false) }

    before { login_as regular_user, scope: :user }

    it 'redirects to root with notice' do
      visit admin_settings_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Reservado para administradores')
    end
  end

  describe 'admin can manage users' do
    let(:admin_user) { create(:user, active: true, admin: true, pretty_name: 'Dr. Admin') }
    let!(:other_user) { create(:user, active: true, pretty_name: 'Dr. Other') }

    before { login_as admin_user, scope: :user }

    it 'shows the users list' do
      visit admin_users_path

      expect(page).to have_content('Dr. Admin')
      expect(page).to have_content('Dr. Other')
    end
  end
end
