Given(/^the following patients exist:$/) do |table|
  log_in(create(:user))
  table.hashes.each do |patient|
    create(:patient,
           first_name: patient[:first_name], last_name: patient[:last_name])
  end
end

When(/^I go to the patients page$/) do
  visit patients_path
end

Then(/^I see Bob and Alice$/) do
  expect(page).to have_content('BOB')
  expect(page).to have_content('ALICE')
end

Given(/^Bob is not a registered patient$/) do
  log_in(create(:user))
  create(:setting, :medical_history_sequence)
  bob = Patient.where(first_name: 'Bob').first
  bob.destroy if bob.present?
end

When(/^I go to the new patient page$/) do
  visit new_patient_path
end

When(/^I input Bob information$/) do
  fill_in :patient_birthdate, with: '1990/02/10'
  fill_in :patient_identity_card_number, with: '0502231248'
  fill_in :patient_last_name, with: 'Bob'
  fill_in :patient_first_name, with: 'Smith'
  fill_in :patient_profession, with: 'Developer'
  click_on 'Guardar'
end

Then(/^I see a creation message$/) do
  expect(page).to have_content('Paciente creado correctamente')
end

Given(/^Bob is a registered patient$/) do
  log_in(create(:user))
  @bob = create(:patient, first_name: 'Bob')
end

When(/^I go to the edit patient page$/) do
  visit edit_patient_path(@bob)
end

When(/^I update Bob's informaton$/) do
  fill_in :patient_last_name, with: 'Rob'
  click_on 'Guardar'
end

Then(/^I see a confirmation message for update$/) do
  expect(page).to have_content('Paciente actualizado correctamente')
end

When(/^I search for Doe$/) do
  fill_in :query, with: 'Doe'
  click_on 'Buscar'
end

Then(/^I see Alice$/) do
  expect(page).to have_content('ALICE')
end

Then(/^I don't see Bob$/) do
  expect(page).to have_no_content('BOB')
end
