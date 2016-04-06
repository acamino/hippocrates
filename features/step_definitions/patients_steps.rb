Given(/^the following patients exist:$/) do |table|
  table.hashes.each do |patient|
    create(:patient, first_name: patient[:first_name])
  end
end

When(/^I go to the patients page$/) do
  visit patients_path
end

Then(/^I see Reed and Sue$/) do
  expect(page).to have_content('Reed')
  expect(page).to have_content('Sue')
end

Given(/^Reed is not a registered patient$/) do
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
