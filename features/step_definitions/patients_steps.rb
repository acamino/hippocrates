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

Then(/^I see Reed and Sue$/) do
  expect(page).to have_content('REED')
  expect(page).to have_content('SUE')
end

Given(/^Reed is not a registered patient$/) do
  log_in(create(:user))
  reed = Patient.where(first_name: 'Reed').first
  reed.destroy if reed.present?
end

When(/^I go to the new patient page$/) do
  visit new_patient_path
end

When(/^I input Reeds information$/) do
  fill_in :patient_birthdate, with: '1990/02/10'
  fill_in :patient_identity_card_number, with: '0502231248'
  fill_in :patient_medical_history, with: '20073'
  fill_in :patient_last_name, with: 'Reed'
  fill_in :patient_first_name, with: 'Richards'
  fill_in :patient_profession, with: 'Developer'
  click_on 'Guardar'
end

Then(/^I see a creation message$/) do
  expect(page).to have_content('Paciente creado correctamente')
end

Given(/^Reed is a registered patient$/) do
  log_in(create(:user))
  @reed = create(:patient, first_name: 'Reed')
end

When(/^I go to the edit patient page$/) do
  visit edit_patient_path(@reed)
end

When(/^I update Reed's informaton$/) do
  fill_in :patient_last_name, with: 'Doom'
  click_on 'Guardar'
end

Then(/^I see an update message$/) do
  expect(page).to have_content('Paciente actualizado correctamente')
end

When(/^I search for Storm$/) do
  fill_in :query, with: 'Storm'
  click_on 'Buscar'
end

Then(/^I see Sue$/) do
  expect(page).to have_content('SUE')
end

Then(/^I don't see Reed$/) do
  expect(page).to have_no_content('Reed')
end
