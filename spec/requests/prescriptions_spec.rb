require 'rails_helper'

RSpec.describe 'Prescriptions', type: :request do
  let(:doctor) do
    create(:user, doctor: true, pretty_name: 'Dr. Smith',
                  registration_acess: 'R12345', phone_number: '555-1234')
  end
  let(:patient) { create(:patient_with_anamnesis) }
  let(:branch_office) do
    create(:branch_office, city: 'Guayaquil', phone_numbers: '04-555-0000')
  end
  let(:consultation) do
    create(:consultation, patient: patient, doctor: doctor,
                          branch_office: branch_office,
                          warning_signs: 'Fever above 39C',
                          recommendations: 'Rest for 3 days')
  end

  before do
    create(:setting, :emergency_number)
    create(:setting, :website)
    login_as doctor, scope: :user
  end

  describe 'GET /patients/:patient_id/consultations/:consultation_id/prescription' do
    before do
      create(:prescription, consultation: consultation)
    end

    it 'returns a PDF with accepted status' do
      get patient_consultation_prescription_path(patient, consultation)

      expect(response).to have_http_status(:accepted)
      expect(response.content_type).to include('application/pdf')
    end

    context 'with empty: true' do
      it 'returns a PDF without prescriptions content' do
        get patient_consultation_prescription_path(patient, consultation),
            params: { empty: true }

        expect(response).to have_http_status(:accepted)
        expect(response.content_type).to include('application/pdf')
      end
    end
  end
end
