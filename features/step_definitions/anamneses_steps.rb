Given(/^Bob is an existing patient$/) do
  log_in(create(:user))
  @bob = create(:patient, first_name: 'Bob')

  create(:setting, :maximum_diagnoses)
  create(:setting, :maximum_prescriptions)
  create(:setting, :medical_history_sequence)
end

When(/^I go to the new anamnesis page$/) do
  visit new_patient_anamnesis_path(@bob)
end

When(/^I input Bob's anamnesis$/) do
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
