require 'rails_helper'

RSpec.describe 'Patients', type: :request do
  before do
    create(:setting, :medical_history_sequence, value: '4')
    login_as create(:user), scope: :user
  end

  describe 'GET /patients' do
    before do
      create(:patient)
      get patients_path
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET /patients/new' do
    before { get new_patient_path }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /patients' do
    context 'when the information is complete' do
      let(:attributes_for_patient) { attributes_for(:patient) }

      it 'creates a patient' do
        expect do
          post patients_path, params: { patient: attributes_for_patient }
        end.to change(Patient, :count).by(1)
      end

      it 'updates the medical history sequence' do
        post patients_path, params: { patient: attributes_for_patient }
        expect(Setting::MedicalHistorySequence.next).to eq(6)
      end

      it 'redirects to new anamnesis' do
        post patients_path, params: { patient: attributes_for_patient }
        expect(response).to redirect_to(new_patient_anamnesis_path(Patient.last))
      end
    end

    context 'when the information is incomplete' do
      let(:attributes_for_patient) do
        attributes_for(:patient).except(:first_name)
      end

      it 'does not create a patient' do
        expect do
          post patients_path, params: { patient: attributes_for_patient }
        end.not_to change(Patient, :count)
      end

      it 'does not update the medical history sequence' do
        post patients_path, params: { patient: attributes_for_patient }
        expect(Setting::MedicalHistorySequence.next).to eq(5)
      end

      it 're-renders new' do
        post patients_path, params: { patient: attributes_for_patient }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /patients/export' do
    before { create_list(:patient, 2) }

    context 'when the user is an admin' do
      before { login_as create(:user, admin: true), scope: :user }

      it 'returns a spreadsheet' do
        get export_patients_path
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('spreadsheetml')
      end
    end

    context 'when the user is a super_admin' do
      before { login_as create(:user, super_admin: true), scope: :user }

      it 'returns a spreadsheet' do
        get export_patients_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user is not an admin' do
      it 'redirects to root path' do
        get export_patients_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /patients/:id/edit' do
    let(:patient) { create(:patient) }

    before { get edit_patient_path(patient) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'PUT /patients/:id' do
    let(:patient) { create(:patient, first_name: 'Bob') }

    context 'when the information is valid' do
      before do
        put patient_path(patient), params: { patient: { first_name: 'Chad' } }
      end

      it 'updates the patient' do
        expect(patient.reload.first_name).to eq('CHAD')
      end

      it { expect(response).to redirect_to(patients_path) }
    end

    context 'when the information is invalid' do
      before do
        put patient_path(patient), params: { patient: { first_name: '' } }
      end

      it 'does not update the patient' do
        expect(patient.reload.first_name).to eq('BOB')
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'DELETE /patients/:id' do
    let!(:patient) { create(:patient) }
    let!(:anamnesis) { create(:anamnesis, patient: patient) }

    before do
      create_list(:consultation, 2, patient: patient)
      create(:activity, owner: patient)
    end

    context 'when the user is a doctor' do
      before do
        login_as create(:user, doctor: true), scope: :user
      end

      it 'discards the patient and related models' do
        expect do
          delete patient_path(patient)
          patient.reload
          anamnesis.reload
        end.to(
          change(patient, :discarded?).from(false).to(true)
          .and(change(anamnesis, :discarded?).from(false).to(true))
        )
      end

      it 'redirects to patients index' do
        delete patient_path(patient)
        expect(response).to redirect_to(patients_path)
      end
    end

    context 'when the user is an admin' do
      before do
        login_as create(:user, admin: true), scope: :user
      end

      it 'discards the patient' do
        expect do
          delete patient_path(patient)
          patient.reload
        end.to change(patient, :discarded?).from(false).to(true)
      end
    end

    context 'when the user is a super_admin' do
      before do
        login_as create(:user, super_admin: true), scope: :user
      end

      it 'discards the patient' do
        expect do
          delete patient_path(patient)
          patient.reload
        end.to change(patient, :discarded?).from(false).to(true)
      end
    end

    context 'when the user is not authorized' do
      before do
        login_as create(:user, doctor: false, admin: false, super_admin: false), scope: :user
      end

      it 'does not discard the patient' do
        expect do
          delete patient_path(patient)
          patient.reload
        end.not_to change(patient, :discarded?)
      end

      it 'redirects to root path' do
        delete patient_path(patient)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
