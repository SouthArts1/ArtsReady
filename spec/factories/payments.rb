FactoryGirl.define do
  factory :payment do
    subscription_event

    amount_in_cents 30000
    account_type 'Visa'
    account_number '9263'
  end
end