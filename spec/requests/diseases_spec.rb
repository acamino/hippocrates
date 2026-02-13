require 'rails_helper'

RSpec.describe 'Diseases', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /diseases' do
    before do
      create(:disease)
      get diseases_path
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /diseases/new' do
    before { get new_disease_path }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /diseases' do
    context 'when the information is complete' do
      let(:attributes_for_disease) { attributes_for(:disease) }

      it 'creates a disease' do
        expect do
          post diseases_path, params: { disease: attributes_for_disease }
        end.to change(Disease, :count).by(1)
      end

      it 'redirects to diseases index' do
        post diseases_path, params: { disease: attributes_for_disease }
        expect(response).to redirect_to(diseases_path)
      end
    end

    context 'when the information is incomplete' do
      let(:attributes_for_disease) do
        attributes_for(:disease).except(:code)
      end

      it 'does not create a disease' do
        expect do
          post diseases_path, params: { disease: attributes_for_disease }
        end.not_to change(Disease, :count)
      end

      it 're-renders new' do
        post diseases_path, params: { disease: attributes_for_disease }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /diseases/:id/edit' do
    let(:disease) { create(:disease) }

    before { get edit_disease_path(disease) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PATCH /diseases/:id' do
    let(:disease) { create(:disease, name: 'pharyngitis') }

    context 'when the information is valid' do
      before do
        patch disease_path(disease), params: { disease: { name: 'rhinitis' } }
      end

      it 'updates the disease' do
        expect(disease.reload.name).to eq('RHINITIS')
      end

      it { expect(response).to redirect_to(diseases_path) }
    end

    context 'when the information is invalid' do
      before do
        put disease_path(disease), params: { disease: { name: '' } }
      end

      it 'does not update the disease' do
        expect(disease.reload.name).to eq('PHARYNGITIS')
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'DELETE /diseases/:id' do
    let!(:disease) { create(:disease) }

    it 'deletes the disease' do
      expect do
        delete disease_path(disease)
      end.to change(Disease, :count).from(1).to(0)
    end

    it 'redirects to diseases index' do
      delete disease_path(disease)
      expect(response).to redirect_to(diseases_path)
    end
  end
end
