FactoryGirl.define do
  factory :payment do
    organization
    amount_in_cents 30000
    account_type 'Visa'
    account_number '9263'
    paid_at Time.zone.now
  end
end