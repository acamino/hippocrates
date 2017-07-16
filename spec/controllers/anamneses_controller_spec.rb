require 'rails_helper'

describe AnamnesesController do
  before { sign_in_user_mock }

  describe '#new' do
    let(:patient) { double(:patient) }
    let(:anamnesis) { double(:anamnesis) }

    before do
      allow(Patient).to receive(:find).with('1') { patient }
      allow(Anamnesis).to receive(:new) { anamnesis }
      get :new, params: { patient_id: '1' }
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it 'assings @anamnesis' do
      expect(assigns(:anamnesis)).to eq(anamnesis)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    let(:patient)                  { create(:patient) }
    let(:attributes_for_anamnesis) { attributes_for(:anamnesis) }

    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, params: { anamnesis: attributes_for_anamnesis,
                                patient_id: patient.id.to_s }
      end
    end

    it 'creates a new anamnesis', :skip_on_before do
      expect do
        post :create, params: { anamnesis: attributes_for_anamnesis,
                                patient_id: patient.id.to_s }
      end.to change { Anamnesis.count }.by(1)
    end

    it { is_expected.to redirect_to new_patient_consultation_path(patient) }
    it { is_expected.to respond_with :redirect }
  end

  describe '#edit' do
    let(:patient) { double(:patient) }
    let(:anamnesis) { double(:anamnesis) }

    before do
      allow(Patient).to receive(:find).with('1') { patient }
      allow(Anamnesis).to receive(:find).with('1') { anamnesis }
      get :edit, params: { id: '1', patient_id: '1' }
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it 'assings @anamnesis' do
      expect(assigns(:anamnesis)).to eq(anamnesis)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let(:patient) { create(:patient_with_anamnesis) }

    before do
      put :update, params: { patient_id: patient.id,
                             id: patient.anamnesis.id,
                             anamnesis: { family_history: 'family history updated' } }
    end

    it 'updates the patient' do
      patient.reload
      expect(patient.anamnesis.family_history).to eq('FAMILY HISTORY UPDATED')
    end

    it { is_expected.to redirect_to patients_path }
    it { is_expected.to respond_with :redirect }
  end
end
