require 'rails_helper'

RSpec.describe 'SpecialPatients', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /patients/special' do
    before do
      create(:patient, :special, :with_consultations)
      create(:patient, :with_consultations)
      get special_patients_path
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'DELETE /patients/:id/remove_special' do
    let!(:patient) { create(:patient, :special) }

    it 'removes patient from special' do
      expect do
        delete remove_special_patient_path(patient)
      end.to change { patient.reload.special }.from(true).to(false)
    end

    it 'redirects to special patients' do
      delete remove_special_patient_path(patient)
      expect(response).to redirect_to(special_patients_path)
    end
  end
end
