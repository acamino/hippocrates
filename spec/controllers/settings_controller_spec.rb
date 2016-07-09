require 'rails_helper'

describe SettingsController do
  before { sign_in_user_mock }

  describe '#index' do
    before do
      get :index
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end
end
