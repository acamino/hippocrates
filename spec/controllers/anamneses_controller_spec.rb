require 'rails_helper'

describe AnamnesesController do
  describe '#new' do
    let(:patient) { double(:patient) }
    let(:anamnesis) { double(:anamnesis) }

    before do
      allow(Patient).to receive(:find).with("1") { patient }
      allow(Anamnesis).to receive(:new) { anamnesis }
      get :new, patient_id: "1"
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
    let(:patient)    { create(:patient) }
    let(:attributes_for_anamnesis) do
      {
        personal_history: 'personal history',
        surgical_history: 'surgical history',
        allergies: 'allergies',
        observations: 'observations',
        habits: 'habits',
        family_history: 'family history'
      }
    end

    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, anamnesis: attributes_for_anamnesis,
                      patient_id: patient.id.to_s
      end
    end

    it 'creates a new anamnesis', :skip_on_before do
      expect do
        post :create, anamnesis: attributes_for_anamnesis,
          patient_id: patient.id.to_s
      end.to change{ Anamnesis.count }.by(1)
    end

    it { is_expected.to redirect_to patients_path }
    it { is_expected.to respond_with :redirect }
  end
end
