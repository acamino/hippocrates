Given(/^Bob is an existing patient$/) do
  @bob = create(:patient, first_name: 'Bob')
end

When(/^I go to the new anamnesis page$/) do
  visit new_patient_anamnesis_path(@bob)
end

When(/^I input Bob's anamnesis$/) do
  fill_in :anamnesis_personal_history, with: 'personal history'
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
