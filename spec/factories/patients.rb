FactoryGirl.define do
  factory :patient do
    sequence(:medical_history)      { |n| 20_000 + n }
    sequence(:identity_card_number) { |n| "icn-#{n}" }

    first_name     'Reed'
    last_name      'Richards'
    birthdate      30.years.ago
    gender         'male'
    civil_status   'married'
    source         'patient_reference'
  end
end
