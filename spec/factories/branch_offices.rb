FactoryBot.define do
  factory :branch_office do
    sequence(:name) { |n| "name-#{n}" }
  end
end
