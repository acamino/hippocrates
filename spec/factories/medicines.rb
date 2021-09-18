FactoryBot.define do
  factory :medicine do
    sequence(:name) { |n| "name-#{n}" }
    instructions { 'instructions' }
  end
end
