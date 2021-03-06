FactoryGirl.define do
  factory :subscription do
    starting_amount_in_cents 100
    regular_amount_in_cents 100

    billing_first_name 'Bill'
    billing_last_name "Lastname"
    billing_address '100 Test St'
    billing_city 'New York'
    billing_state 'NY'
    billing_zipcode '10001'
    billing_phone_number '555-555-1212'
    billing_email 'bill_lastname@example.com'

    active true

    factory :provisional_subscription, class: ProvisionalSubscription do
      factory :inactive_provisional_subscription do
        active false
      end
    end

    factory :authorize_net_subscription, class: AuthorizeNetSubscription do
      payment_method 'Credit Card'
      payment_type 'cc' # why both?!?
      number '4007000000027'
      expiry_month '1'
      expiry_year { Time.now.year + 3 }
      ccv '888'

      factory :subscription_with_discount_code do
        discount_code
      end

      factory :expiring_subscription do
        ignore do
          expiration { Time.zone.now }
        end

        expiry_month { expiration.month }
        expiry_year { expiration.year }
      end
    end
  end
end