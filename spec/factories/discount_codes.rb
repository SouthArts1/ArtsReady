FactoryGirl.define do
  factory :discount_code do
    discount_code 'DISCO'
    redemption_max 24
    active_on { Date.yesterday.beginning_of_day }
    expires_on { Date.tomorrow.end_of_day }
  end
end
