Given(/^Ada has a consultation with documents$/) do
  log_in(create(:user, doctor: true, active: true, editor: true))
  @ada = create(:patient_with_anamnesis, first_name: 'Ada', last_name: 'Lovelace')
  @consultation = create(:consultation, patient: @ada)
  @document = @consultation.documents.create!(description: 'Lab results')
end

Given(/^Ada has a consultation$/) do
  log_in(create(:user, doctor: true, active: true, editor: true))
  @ada = create(:patient_with_anamnesis, first_name: 'Ada', last_name: 'Lovelace')
  @consultation = create(:consultation, patient: @ada)
end

When(/^I open her documents page$/) do
  visit patient_consultation_documents_path(@ada, @consultation)
end

When(/^I open create document page$/) do
  visit new_patient_consultation_document_path(@ada, @consultation)
end

When(/^I input document information$/) do
  fill_in :document_description, with: 'X-ray results'
  click_on 'Guardar'
end

When(/^I open edit document page$/) do
  visit edit_patient_consultation_document_path(@ada, @consultation, @document)
end

When(/^I update document information$/) do
  fill_in :document_description, with: 'Updated lab results'
  click_on 'Guardar'
end

When(/^I delete the document$/) do
  visit edit_patient_consultation_document_path(@ada, @consultation, @document)
  click_link 'Eliminar'
end
