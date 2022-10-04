FactoryBot.define do
  factory :setting do
    sequence(:name) { |n| "name-#{n}" }
    value { 'value' }
  end

  trait :maximum_diagnoses do
    name  { Setting::MAXIMUM_DIAGNOSES }
    value { '4' }
  end

  trait :maximum_prescriptions do
    name  { Setting::MAXIMUM_PRESCRIPTIONS }
    value { '4' }
  end

  trait :medical_history_sequence do
    name  { Setting::MEDICAL_HISTORY_SEQUENCE }
    value { '4' }
  end

  trait :emergency_number do
    name  { Setting::EMERGENCY_NUMBER }
    value { '099 555 5555' }
  end
end
