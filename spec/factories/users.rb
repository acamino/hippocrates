FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "bob-#{n}@example.com" }
    sequence(:registration_acess) { |n| "000000000#{n}" }
    password 's3cret'
  end
end
