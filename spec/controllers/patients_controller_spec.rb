require 'rails_helper'

describe PatientsController do
  describe '#index' do
    let(:patients) { [double(:patient)] }

    before do
      allow(Patient).to receive(:all) { patients }
      get :index
    end

    it 'assings @patients' do
      expect(assigns(:patients)).to eq(patients)
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    let(:patient) { double(:patient) }

    before do
      allow(Patient).to receive(:new) { patient }
      get :new
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, patient: attributes_for_patient
      end
    end

    context 'when the information is complete' do
      let(:attributes_for_patient) { attributes_for(:patient) }

      it 'creates a patient', :skip_on_before do
        expect do
          post :create, patient: attributes_for_patient
        end.to change{ Patient.count }.by(1)
      end

      it { is_expected.to redirect_to patients_path }
      it { is_expected.to respond_with :redirect }
    end

    context 'when the information is incomplete' do
      let(:attributes_for_patient) do
        attributes_for(:patient).except(:first_name)
      end

      it 'does not create a patient', :skip_on_before do
        expect do
          post :create, patient: attributes_for_patient
        end.to change{ Patient.count }.by(0)
      end

      it { is_expected.to render_template :new }
      it { is_expected.to respond_with :ok }
    end
  end
end
