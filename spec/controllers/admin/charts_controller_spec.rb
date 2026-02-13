require 'rails_helper'

describe Admin::ChartsController do
  before do
    sign_in_user_mock(admin_or_super_admin?: true)
    allow_any_instance_of(Charts::Payments::Builder).to receive(:call).and_return([])
    allow_any_instance_of(Charts::Consultations::Builder).to receive(:call).and_return([])
  end

  describe '#index' do
    before { get :index }

    it 'assigns @payments_chart' do
      expect(assigns(:payments_chart)).to eq([])
    end

    it 'assigns @consultations_chart' do
      expect(assigns(:consultations_chart)).to eq([])
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end
end
