require 'rails_helper'

describe Admin::BranchOfficesController do
  before { sign_in_user_mock(admin_or_super_admin?: true) }

  describe '#index' do
    before do
      create(:branch_office)
      get :index
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    before { get :new }

    it 'assigns @branch_office' do
      expect(assigns(:branch_office)).to be_a_new(BranchOffice)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    context 'when the information is valid' do
      it 'creates a branch office' do
        expect {
          post :create, params: { branch_office: { name: 'New Office' } }
        }.to change(BranchOffice, :count).by(1)
      end

      it 'redirects to index' do
        post :create, params: { branch_office: { name: 'New Office' } }

        is_expected.to redirect_to admin_branch_offices_path
      end
    end

    context 'when the information is invalid' do
      it 'does not create a branch office' do
        expect {
          post :create, params: { branch_office: { name: '' } }
        }.not_to change(BranchOffice, :count)
      end

      it 'renders new' do
        post :create, params: { branch_office: { name: '' } }

        is_expected.to render_template :new
      end
    end
  end

  describe '#edit' do
    let(:office) { create(:branch_office) }

    before { get :edit, params: { id: office.id } }

    it 'assigns @branch_office' do
      expect(assigns(:branch_office)).to eq(office)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let(:office) { create(:branch_office) }

    context 'when the information is valid' do
      before do
        put :update, params: { id: office.id, branch_office: { city: 'Quito' } }
      end

      it 'updates the branch office' do
        expect(office.reload.city).to eq('Quito')
      end

      it { is_expected.to redirect_to admin_branch_offices_path }
    end

    context 'when the information is invalid' do
      before do
        put :update, params: { id: office.id, branch_office: { name: '' } }
      end

      it { is_expected.to render_template :edit }
    end
  end

  describe '#destroy' do
    let!(:office) { create(:branch_office) }

    it 'deletes the branch office' do
      expect {
        delete :destroy, params: { id: office.id }
      }.to change(BranchOffice, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: office.id }

      is_expected.to redirect_to admin_branch_offices_path
    end
  end
end
