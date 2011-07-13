# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :organization do |f|
  f.name "Test Organization"
  f.address "100 Test St"
  f.city "New York"
  f.state "NY"
  f.zipcode "10001"
  f.active true
  f.latitude 33.8039 
  f.longitude -84.3933 
  f.gmaps true
  f.declared_crisis false
end

Factory.define :new_organization, :parent => :organization do |f|
  f.name "New Organization"
  f.active false
end

Factory.define :crisis_organization, :parent => :organization do |f|
  f.name "Crisis Organization"
  f.declared_crisis true
end