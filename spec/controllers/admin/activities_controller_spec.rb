require 'rails_helper'

describe Admin::ActivitiesController do
  before { sign_in_user_mock(admin_or_super_admin?: true) }

  describe '#index' do
    before { get :index }

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end
end
