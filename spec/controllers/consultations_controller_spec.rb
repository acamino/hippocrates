require 'rails_helper'

describe ConsultationsController do
  describe '#new' do
    let(:patient)      { double(:patient) }
    let(:consultation) { double(:consultation) }

    before do
      allow(Patient).to receive(:find).with('1') { patient }
      allow(Consultation).to receive(:new) { consultation }
      get :new, patient_id: '1'
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it 'assings @consultation' do
      expect(assigns(:consultation)).to eq(consultation)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    let(:patient)                     { create(:patient) }
    let(:attributes_for_consultation) { attributes_for(:consultation) }

    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, patient_id: patient.id.to_s,
                      consultation: attributes_for_consultation
      end
    end

    it 'creates a new consultation', :skip_on_before do
      expect do
        post :create, patient_id: patient.id.to_s,
                      consultation: attributes_for_consultation
      end.to change { Consultation.count }.by(1)
    end

    it { is_expected.to redirect_to patients_path }
    it { is_expected.to respond_with :redirect }
  end
end
