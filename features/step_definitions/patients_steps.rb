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
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I input Reeds information$/) do
  fill_in :first_name, 'Reed'
  click 'Guardar'
end

Then(/^I see a creation message$/) do
  expect(page).to have_content('Patient created successfully')
end
