Given(/^the following patients:$/) do |table|
  log_in(create(:user))
  table.hashes.each do |patient|
    create(
      :patient, first_name: patient[:first_name], last_name: patient[:last_name]
    )
  end
end

When(/^I open patients page$/) do
  visit patients_path
end

Given(/^Charles is not a patient$/) do
  log_in(create(:user))
  create(:setting, :medical_history_sequence)
  charles = Patient.where(first_name: 'Charles').first
  charles.destroy if charles.present?
end

When(/^I open create patient page$/) do
  visit new_patient_path
end

When(/^I input Charles information$/) do
  fill_in :patient_birthdate, with: '1990/02/10'
  fill_in :patient_identity_card_number, with: '0502231248'
  fill_in :patient_last_name, with: 'Charles'
  fill_in :patient_first_name, with: 'Babbage'
  fill_in :patient_profession, with: 'Mathematician'
  click_on 'Guardar'
end

Then(/^I see a success message for creation$/) do
  expect(page).to have_content('Paciente creado correctamente')
end

When(/^I open edit patient page$/) do
  visit edit_patient_path(@ada)
end

When(/^I update Ada's informaton$/) do
  fill_in :patient_last_name, with: 'Lovelace'
  click_on 'Guardar'
end

Then(/^I see a success message for update$/) do
  expect(page).to have_content('Paciente actualizado correctamente')
end

When(/^I search for Ada$/) do
  fill_in :query, with: 'Ada'
  click_on 'Buscar'
end

Then(/^I see "(.+)"$/) do |content|
  expect(page).to have_content(/#{content}/i)
end

But(/^I don't see "(.+)"$/) do |content|
  expect(page).to have_no_content(/#{content}/i)
end
