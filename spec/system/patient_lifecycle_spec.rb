require 'rails_helper'

RSpec.describe 'Patient lifecycle', type: :system do
  let(:user) { create(:user, active: true, doctor: true, editor: true) }
  let!(:branch_office) { create(:branch_office, active: true) }
  let!(:max_diagnoses)     { create(:setting, :maximum_diagnoses) }
  let!(:max_prescriptions) { create(:setting, :maximum_prescriptions) }
  let!(:med_history_seq)   { create(:setting, :medical_history_sequence) }

  before { login_as user, scope: :user }

  describe 'full lifecycle: create patient, anamnesis, consultation' do
    it 'completes the patient creation flow' do
      visit new_patient_path

      fill_in 'patient_identity_card_number', with: '1234567890'
      fill_in 'patient_last_name', with: 'Garcia'
      fill_in 'patient_first_name', with: 'Carlos'
      fill_in 'patient_birthdate', with: '1990-01-15'
      select 'Masculino', from: 'patient_gender'
      select 'Soltero', from: 'patient_civil_status'
      select 'Instagram', from: 'patient_source'
      select branch_office.name, from: 'patient_branch_office_id'
      check 'patient_data_management_consent'
      click_button 'Guardar'

      expect(page).to have_content('Paciente creado correctamente')

      # Should be on anamnesis new page
      fill_in 'anamnesis_medical_history', with: 'No relevant history'
      fill_in 'anamnesis_surgical_history', with: 'None'
      fill_in 'anamnesis_allergies', with: 'None'
      click_button 'Guardar'

      expect(page).to have_content('Anamnesis creada correctamente')

      # Should be on consultation new page
      fill_in 'consultation_reason', with: 'Routine checkup'
      fill_in 'consultation_payment', with: '50'
      click_button 'Guardar'

      expect(page).to have_content('Consulta creada correctamente')
    end
  end

  describe 'patient search' do
    let!(:patient_a) do
      create(:patient, first_name: 'Ana', last_name: 'Martinez',
                       branch_office: branch_office)
    end
    let!(:patient_b) do
      create(:patient, first_name: 'Pedro', last_name: 'Lopez',
                       branch_office: branch_office)
    end

    it 'filters patients by name' do
      visit patients_path(query: 'Ana')

      expect(page).to have_content('MARTINEZ')
      expect(page).not_to have_content('LOPEZ')
    end
  end

  describe 'patient archive (soft delete)' do
    let!(:patient) do
      create(:patient, first_name: 'ToArchive', last_name: 'Patient',
                       branch_office: branch_office)
    end

    it 'removes the patient from the index' do
      visit patients_path

      expect(page).to have_content('TOARCHIVE')

      page.find("a[href='#{patient_path(patient)}'][data-method='delete']").click

      expect(page).to have_content('eliminado correctamente')
      within('tbody') do
        expect(page).not_to have_content('TOARCHIVE')
      end
    end
  end
end
