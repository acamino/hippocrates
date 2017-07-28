Given(/^Ada is an patient$/) do
  log_in(create(:user))
  @ada = create(:patient, first_name: 'Ada')

  create(:setting, :maximum_diagnoses)
  create(:setting, :maximum_prescriptions)
  create(:setting, :medical_history_sequence)
end

When(/^I open create anamnesis page$/) do
  visit new_patient_anamnesis_path(@ada)
end

When(/^I input Ada's anamnesis$/) do
  fill_in :anamnesis_surgical_history, with: 'surgical history'
  fill_in :anamnesis_allergies,        with: 'allergies'
  fill_in :anamnesis_observations,     with: 'observations'
  fill_in :anamnesis_habits,           with: 'habits'
  fill_in :anamnesis_family_history,   with: 'family history'
  click_on 'Guardar'
end

Then(/^I see a confirmation message$/) do
  expect(page).to have_content('Anamnesis creada correctamente')
end
