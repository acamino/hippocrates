Given(/^the following diseases:$/) do |table|
  table.hashes.each do |disease|
    create(
      :disease, code: disease[:code], name: disease[:name]
    )
  end
end

When(/^I open diseases page$/) do
  visit diseases_path
end

When(/^I open create disease page$/) do
  step 'I open diseases page'
  click_link 'Nueva enfermedad'
end

When(/^I input disease information$/) do
  fill_in :disease_code, with: 'D001'
  fill_in :disease_name, with: 'Flu'
  click_on 'Guardar'
end

Given(/^Flu is a disease$/) do
  create(
    :disease, code: 'D001', name: 'Flu'
  )
end

When(/^I open edit disease page$/) do
  step 'I open diseases page'
  click_link 'Editar'
end
