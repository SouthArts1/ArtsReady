# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :discount do
    discount_code "MyString"
    deduction_value 1
    deduction_type "MyString"
    redemption_max 1
    active_on "2012-05-21 11:13:20"
    expires_on "2012-05-21 11:13:20"
  end
end
