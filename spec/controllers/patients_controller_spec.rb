require 'rails_helper'

describe PatientsController do
  before do
    create(:setting, :medical_history_sequence, value: '4')
    sign_in_user_mock
  end

  describe '#index' do
    let(:patients) { [create(:patient)] }

    before do
      get :index
    end

    it 'assings @patients' do
      expect(assigns(:patients)).to eq(patients)
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    before { get :new }

    it 'assings @patient' do
      expect(assigns(:patient)).to be_a_new(PatientPresenter)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, params: { patient: attributes_for_patient }
      end
    end

    context 'when the information is complete' do
      let(:attributes_for_patient) { attributes_for(:patient) }

      it 'creates a patient', :skip_on_before do
        expect do
          post :create, params: { patient: attributes_for_patient }
        end.to change { Patient.count }.by(1)
      end

      it 'updates the medical history sequence', :skip_on_before do
        post :create, params: { patient: attributes_for_patient }
        expect(Setting::MedicalHistorySequence.next).to eq(6)
      end

      it do
        patient = Patient.last
        is_expected.to redirect_to new_patient_anamnesis_path(patient)
      end

      it { is_expected.to respond_with :redirect }
    end

    context 'when the information is incomplete' do
      let(:attributes_for_patient) do
        attributes_for(:patient).except(:first_name)
      end

      it 'does not create a patient', :skip_on_before do
        expect do
          post :create, params: { patient: attributes_for_patient }
        end.to change { Patient.count }.by(0)
      end

      it 'does not update the medical history sequence', :skip_on_before do
        post :create, params: { patient: attributes_for_patient }
        expect(Setting::MedicalHistorySequence.next).to eq(5)
      end

      it { is_expected.to render_template :new }
      it { is_expected.to respond_with :ok }
    end
  end

  describe '#edit' do
    let(:patient) { double(:patient) }

    before do
      allow(Patient).to receive(:find).with('1') { patient }
      get :edit, params: { id: '1' }
    end

    it 'assings @patient' do
      expect(assigns(:patient)).to eq(patient)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let(:patient) { create(:patient, first_name: 'Bob') }

    context 'when the information is valid' do
      before { put :update, params: { id: patient.id, patient: { first_name: 'Chad' } } }

      it 'updates the patient' do
        expect(patient.reload.first_name).to eq('CHAD')
      end

      it { is_expected.to redirect_to patients_path }
      it { is_expected.to respond_with :redirect }
    end

    context 'when the information is invalid' do
      before { put :update, params: { id: patient.id, patient: { first_name: '' } } }

      it 'do not update the patient' do
        expect(patient.reload.first_name).to eq('BOB')
      end

      it { is_expected.to render_template :edit }
      it { is_expected.to respond_with :ok }
    end
  end

  describe '#destroy' do
    let!(:patient) { create(:patient) }
    let!(:anamnesis) { create(:anamnesis, patient: patient) }

    before do |example|
      create_list(:consultation, 2, patient: patient)
      create(:activity, owner: patient)

      delete :destroy, params: { id: patient.id } unless example.metadata[:skip_on_before]
    end

    it 'deletes the patient and the related models', :skip_on_before do
      expect do
        delete :destroy, params: { id: patient.id }
        patient.reload
        anamnesis.reload
      end.to(
        change(patient, :discarded?).from(false).to(true)
        .and(change(anamnesis, :discarded?).from(false).to(true))
      )
    end

    it { is_expected.to redirect_to patients_path }
  end
end
