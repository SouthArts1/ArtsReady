# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :need do |f|
  f.organization_id 1
  f.crisis_id 1
  f.resource "MyString"
  f.description "MyText"
  f.provided false
  f.provider "MyString"
  f.last_updated_on "2011-07-15"
end