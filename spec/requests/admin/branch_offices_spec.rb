require 'rails_helper'

RSpec.describe 'Admin::BranchOffices', type: :request do
  before { login_as create(:user, admin: true), scope: :user }

  describe 'GET /admin/branch_offices' do
    before do
      create(:branch_office)
      get admin_branch_offices_path
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /admin/branch_offices/new' do
    before { get new_admin_branch_office_path }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /admin/branch_offices' do
    context 'when the information is valid' do
      it 'creates a branch office' do
        expect do
          post admin_branch_offices_path,
               params: { branch_office: { name: 'New Office' } }
        end.to change(BranchOffice, :count).by(1)
      end

      it 'redirects to index' do
        post admin_branch_offices_path,
             params: { branch_office: { name: 'New Office' } }

        expect(response).to redirect_to(admin_branch_offices_path)
      end
    end

    context 'when the information is invalid' do
      it 'does not create a branch office' do
        expect do
          post admin_branch_offices_path,
               params: { branch_office: { name: '' } }
        end.not_to change(BranchOffice, :count)
      end

      it 're-renders new' do
        post admin_branch_offices_path,
             params: { branch_office: { name: '' } }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /admin/branch_offices/:id/edit' do
    let(:office) { create(:branch_office) }

    before { get edit_admin_branch_office_path(office) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PUT /admin/branch_offices/:id' do
    let(:office) { create(:branch_office) }

    context 'when the information is valid' do
      before do
        put admin_branch_office_path(office),
            params: { branch_office: { city: 'Quito' } }
      end

      it 'updates the branch office' do
        expect(office.reload.city).to eq('Quito')
      end

      it { expect(response).to redirect_to(admin_branch_offices_path) }
    end

    context 'when the information is invalid' do
      before do
        put admin_branch_office_path(office),
            params: { branch_office: { name: '' } }
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'DELETE /admin/branch_offices/:id' do
    let!(:office) { create(:branch_office) }

    it 'deletes the branch office' do
      expect do
        delete admin_branch_office_path(office)
      end.to change(BranchOffice, :count).by(-1)
    end

    it 'redirects to index' do
      delete admin_branch_office_path(office)
      expect(response).to redirect_to(admin_branch_offices_path)
    end
  end
end
