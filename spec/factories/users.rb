FactoryBot.define do
  factory :user do
    sequence(:email)              { |n| "bob-#{n}@example.com" }
    sequence(:registration_acess) { |n| "r000000000-#{n}" }
    sequence(:pretty_name)        { |n| "Dr. Bob #{n}" }
    password { 's3cret' }
  end
end
