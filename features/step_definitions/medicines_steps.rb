Given(/^I am a logged user$/) do
  log_in(create(:user))
end

Given(/^the following medicines:$/) do |table|
  table.hashes.each do |medicine|
    create(
      :medicine, name: medicine[:name], instructions: medicine[:instructions]
    )
  end
end

When(/^I open medicines page$/) do
  visit medicines_path
end

When(/^I open create medicine page$/) do
  step 'I open medicines page'
  click_link 'Nueva medicina'
end

When(/^I input medicine information$/) do
  fill_in :medicine_name, with: 'Buprex'
  fill_in :medicine_instructions, with: 'Buprex instructions'
  click_on 'Guardar'
end

Given(/^Paracetamol is a medicine$/) do
  create(
    :medicine, name: 'Paracetamol', instructions: 'Paracetamol instructions'
  )
end

When(/^I open edit medicine page$/) do
  step 'I open medicines page'
  click_link 'Editar'
end

When(/^I query for "(.+)"$/) do |content|
  fill_in :query, with: content
  click_on 'Buscar'
end
