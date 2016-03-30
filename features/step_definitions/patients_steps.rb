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
