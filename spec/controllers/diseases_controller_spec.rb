require 'rails_helper'

describe DiseasesController do
  before { sign_in_user_mock }

  describe '#index' do
    let(:diseases) { [create(:disease)] }

    before do
      get :index
    end

    it 'assings @diseases' do
      expect(assigns(:diseases)).to eq(diseases)
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    before do
      get :new
    end

    it 'assings @disease' do
      expect(assigns(:disease)).to be_a_new(Disease)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, disease: attributes_for_disease
      end
    end

    context 'when the information is complete' do
      let(:attributes_for_disease) { attributes_for(:disease) }

      it 'creates a disease', :skip_on_before do
        expect do
          post :create, disease: attributes_for_disease
        end.to change { Disease.count }.by(1)
      end

      it { is_expected.to redirect_to diseases_path }
      it { is_expected.to respond_with :redirect }
    end

    context 'when the information is incomplete' do
      let(:attributes_for_disease) do
        attributes_for(:disease).except(:code)
      end

      it 'does not create a disease', :skip_on_before do
        expect do
          post :create, disease: attributes_for_disease
        end.to change { Disease.count }.by(0)
      end

      it { is_expected.to render_template :new }
      it { is_expected.to respond_with :ok }
    end
  end

  describe '#edit' do
    let(:disease) { double(:disease) }

    before do
      allow(Disease).to receive(:find).with('1') { disease }
      get :edit, id: '1'
    end

    it 'assings @disease' do
      expect(assigns(:disease)).to eq(disease)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let(:disease) { create(:disease, name: 'pharyngitis') }

    context 'when the information is valid' do
      before { patch :update, id: disease.id, disease: { name: 'rhinitis' } }

      it 'updates the disease' do
        expect(disease.reload.name).to eq('RHINITIS')
      end

      it { is_expected.to redirect_to diseases_path }
      it { is_expected.to respond_with :redirect }
    end

    context 'when the information is invalid' do
      before { put :update, id: disease.id, disease: { name: '' } }

      it 'do not update the disease' do
        expect(disease.reload.name).to eq('PHARYNGITIS')
      end

      it { is_expected.to render_template :edit }
      it { is_expected.to respond_with :ok }
    end
  end
end
