FactoryBot.define do
  factory :disease do
    sequence(:code) { |n| "code-#{n}" }
    name { 'name' }
  end
end
