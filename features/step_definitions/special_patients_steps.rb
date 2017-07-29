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
