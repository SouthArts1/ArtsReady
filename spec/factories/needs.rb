FactoryGirl.define do

  factory :need do
    organization_id 1
    crisis_id 1
    resource "MyString"
    description "MyText"
    provided false
    provider "MyString"
    last_updated_on "2011-07-15"
  end

end