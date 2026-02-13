require 'rails_helper'

describe Admin::ChargesController do
  before { sign_in_user_mock(admin_or_super_admin?: true) }

  describe '#index' do
    before { get :index }

    it 'assigns @consultations' do
      expect(assigns(:consultations)).not_to be_nil
    end

    it 'assigns @total_paid' do
      expect(assigns(:total_paid)).not_to be_nil
    end

    it 'assigns @total_pending' do
      expect(assigns(:total_pending)).not_to be_nil
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#export' do
    before do
      create(:consultation)
      get :export
    end

    it 'returns an Excel file' do
      expect(response.content_type).to include('spreadsheetml')
    end

    it { is_expected.to respond_with :ok }
  end
end
