FactoryGirl.define do
  factory :patient do
    sequence(:medical_history)      { |n| 20_000 + n }
    sequence(:identity_card_number) { |n| "icn-#{n}" }

    first_name     'Reed'
    last_name      'Richards'
    birthdate      30.years.ago
    gender         Patient.genders.fetch(:male)
    civil_status   Patient.civil_statuses.fetch(:married)
    source         Patient.sources.fetch(:patient_reference)
  end
end
