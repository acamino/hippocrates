require 'rails_helper'

RSpec.describe 'Consultation management', type: :system do
  let(:doctor) { create(:user, active: true, doctor: true) }
  let!(:branch_office) { create(:branch_office, active: true) }
  let!(:max_diagnoses)     { create(:setting, :maximum_diagnoses) }
  let!(:max_prescriptions) { create(:setting, :maximum_prescriptions) }
  let!(:med_history_seq)   { create(:setting, :medical_history_sequence) }

  before { login_as doctor, scope: :user }

  describe 'consent required' do
    let!(:patient_no_consent) do
      create(:patient_with_anamnesis,
             data_management_consent: false,
             branch_office: branch_office)
    end

    it 'fails when patient has no data management consent' do
      visit new_patient_consultation_path(patient_no_consent)

      fill_in 'consultation_reason', with: 'Checkup'
      fill_in 'consultation_payment', with: '50'
      select branch_office.name, from: 'consultation_branch_office_id'
      click_button 'Guardar'

      expect(page).to have_content('No se puede crear la consulta')
    end
  end

  describe 'doctor payment validation' do
    let!(:patient) do
      create(:patient_with_anamnesis, branch_office: branch_office)
    end

    it 'fails when payment is zero' do
      visit new_patient_consultation_path(patient)

      fill_in 'consultation_reason', with: 'Checkup'
      fill_in 'consultation_payment', with: '0'
      select branch_office.name, from: 'consultation_branch_office_id'
      click_button 'Guardar'

      expect(page).to have_content('No se puede crear la consulta')
    end
  end

  describe 'consultation listing' do
    let!(:patient) do
      create(:patient_with_anamnesis, branch_office: branch_office)
    end
    let!(:older_consultation) do
      create(:consultation, patient: patient, doctor: doctor,
                            branch_office: branch_office,
                            created_at: 2.days.ago,
                            ongoing_issue: 'first visit')
    end
    let!(:newer_consultation) do
      create(:consultation, patient: patient, doctor: doctor,
                            branch_office: branch_office,
                            created_at: 1.day.ago,
                            ongoing_issue: 'follow up')
    end

    it 'shows consultations in descending order' do
      visit patient_consultations_path(patient)

      rows = page.all('tbody tr')
      expect(rows[0]).to have_content('FOLLOW UP')
      expect(rows[1]).to have_content('FIRST VISIT')
    end
  end
end
