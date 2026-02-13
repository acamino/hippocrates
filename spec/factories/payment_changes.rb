FactoryBot.define do
  factory :payment_change do
    previous_payment { 50.00 }
    updated_payment  { 75.00 }
    reason           { 'Price adjustment' }
    type             { :paid }

    user { association :user }
    consultation
  end
end
