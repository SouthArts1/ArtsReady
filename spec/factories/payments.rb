# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    organization_id 1
    amount_in_cents 1
    arb_id 1
    payment_method "MyString"
    payment_number "MyString"
    start_date "2012-05-16 10:01:15"
    end_date "2012-05-16 10:01:15"
    active false
    billing_address_1 "MyString"
    billing_city "MyString"
    billing_state "MyString"
    billing_zipcode "MyString"
  end
end
