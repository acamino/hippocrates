Given(/^Ada is a patient with consultations$/) do
  log_in(create(:user))
  @ada = create(:patient, first_name: 'Ada', last_name: 'Lovelace')
  create(:consultation, patient: @ada, next_appointment: '2017-09-01')
end

When(/^I go to her consultations page$/) do
  visit patient_consultations_path(@ada.id)
end

Then(/^I see her consultations$/) do
  within('tbody') do
    expect(page).to have_content('Sep 01, 2017')
  end
end

Given(/^Ada is a patient$/) do
  log_in(create(:user))
  @ada = create(:patient_with_anamnesis, first_name: 'Ada', last_name: 'Lovelace')

  create(:setting, :maximum_diagnoses)
  create(:setting, :maximum_prescriptions)
  create(:setting, :medical_history_sequence)
end

When(/^I go to create consultation page$/) do
  visit new_patient_consultation_path(@ada.id)
end

When(/^I input consultation info$/) do
  # TODO: Add additional fields
  fill_in :consultation_reason, with: 'consultation reason'
  fill_in :consultation_ongoing_issue, with: 'consultation ongoing issue'
  click_on 'Guardar'
end

Then(/^I see a success message$/) do
  expect(page).to have_content('Consulta creada correctamente')
end
