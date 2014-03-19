FactoryGirl.define do
  factory :payment do
    starting_amount_in_cents 100
    regular_amount_in_cents 100

    billing_first_name 'Bill'
    billing_last_name "Lastname"
    billing_address '100 Test St'
    billing_city 'New York'
    billing_state 'NY'
    billing_zipcode '10001'
    billing_email 'bill_lastname@example.com'

    payment_method 'Credit Card'
    payment_type 'cc' # why both?!?
    number '4007000000027'
    expiry_month '1'
    expiry_year '2017'
    ccv '888'

    active true

    factory :payment_with_discount_code do
      discount_code
    end
  end
end