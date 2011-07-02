# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :organization do |f|
  f.name "Test Organization"
  f.address "100 Test St"
  f.city "New York"
  f.state "NY"
  f.zipcode "10001"
  f.active true
end