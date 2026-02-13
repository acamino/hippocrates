require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  let(:user) { create(:user, active: true) }

  describe 'successful login' do
    it 'redirects to patients index' do
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 's3cret'
      click_button 'Log in'

      expect(page).to have_current_path(root_path)
    end
  end

  describe 'failed login' do
    it 'stays on login page with error' do
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'wrong'
      click_button 'Log in'

      expect(page).to have_content('Iniciar Sesión')
    end
  end

  describe 'inactive user login' do
    let(:inactive_user) { create(:user, active: false) }

    it 'redirects back with inactive message' do
      visit new_user_session_path

      fill_in 'user_email', with: inactive_user.email
      fill_in 'user_password', with: 's3cret'
      click_button 'Log in'

      expect(page).to have_content('Tu usuario está inactivo')
    end
  end

  describe 'unauthenticated redirect' do
    it 'redirects to login page' do
      visit patients_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
