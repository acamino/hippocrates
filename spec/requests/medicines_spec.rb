require 'rails_helper'

RSpec.describe 'Medicines', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /medicines' do
    before do
      create(:medicine)
      get medicines_path
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /medicines/new' do
    before { get new_medicine_path }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /medicines' do
    context 'when the information is complete' do
      let(:attributes_for_medicine) { attributes_for(:medicine) }

      it 'creates a medicine' do
        expect do
          post medicines_path, params: { medicine: attributes_for_medicine }
        end.to change(Medicine, :count).by(1)
      end

      it 'redirects to medicines index' do
        post medicines_path, params: { medicine: attributes_for_medicine }
        expect(response).to redirect_to(medicines_path)
      end
    end

    context 'when the information is incomplete' do
      let(:attributes_for_medicine) do
        attributes_for(:medicine).except(:instructions)
      end

      it 'does not create a medicine' do
        expect do
          post medicines_path, params: { medicine: attributes_for_medicine }
        end.not_to change(Medicine, :count)
      end

      it 're-renders new' do
        post medicines_path, params: { medicine: attributes_for_medicine }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /medicines/:id/edit' do
    let(:medicine) { create(:medicine) }

    before { get edit_medicine_path(medicine) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PATCH /medicines/:id' do
    let(:medicine) { create(:medicine, name: 'paracetamol') }

    context 'when the information is valid' do
      before do
        patch medicine_path(medicine),
              params: { medicine: { name: 'acetaminophen' } }
      end

      it 'updates the medicine' do
        expect(medicine.reload.name).to eq('ACETAMINOPHEN')
      end

      it { expect(response).to redirect_to(medicines_path) }
    end

    context 'when the information is invalid' do
      before do
        put medicine_path(medicine), params: { medicine: { name: '' } }
      end

      it 'does not update the medicine' do
        expect(medicine.reload.name).to eq('PARACETAMOL')
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'DELETE /medicines/:id' do
    let!(:medicine) { create(:medicine) }

    it 'deletes the medicine' do
      expect do
        delete medicine_path(medicine)
      end.to change(Medicine, :count).from(1).to(0)
    end

    it 'redirects to medicines index' do
      delete medicine_path(medicine)
      expect(response).to redirect_to(medicines_path)
    end
  end
end
