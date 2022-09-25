FactoryBot.define do
  factory :activity do
    key { 'anamnesis.viewed' }
    association :trackable, factory: :anamnesis
  end
end
