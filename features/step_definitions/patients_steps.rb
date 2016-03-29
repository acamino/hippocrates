Given(/^Reed and Sue are patients$/) do
  create(:patient, first_name: 'Reed')
  create(:patient, first_name: 'Sue')
end

When(/^I am on the patients page$/) do
  visit root_path
end

Then(/^I see Reed and Sue$/) do
  expect(page).to have_content('Reed')
  expect(page).to have_content('Sue')
end
