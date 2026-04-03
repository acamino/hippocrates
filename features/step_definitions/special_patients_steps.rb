Given(/^the following special patients:$/) do |table|
  log_in(create(:user))
  table.hashes.each do |patient|
    create(
      :patient, :special,
      first_name: patient[:first_name], last_name: patient[:last_name]
    )
  end
end

When(/^I open special patients page$/) do
  visit special_patients_path
end

Given(/^Ada is a special patient$/) do
  log_in(create(:user, doctor: true, active: true, editor: true))
  @ada = create(:patient_with_anamnesis, :special, first_name: 'Ada', last_name: 'Lovelace')
  create(:consultation, patient: @ada)
end

When(/^I remove Ada from special patients$/) do
  page.find("a[href='#{remove_special_patient_path(@ada)}']").click
end
