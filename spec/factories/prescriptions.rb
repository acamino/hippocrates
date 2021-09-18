FactoryBot.define do
  factory :prescription do
    inscription  { 'instructions' }
    subscription { 'subscription' }

    consultation
  end
end
