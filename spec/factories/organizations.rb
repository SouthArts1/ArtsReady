FactoryGirl.define do

  factory :organization do
    name "Test Organization"
    address "100 Test St"
    city "New York"
    state "NY"
    zipcode "10001"
    active true
    latitude 33.8039 
    longitude -84.3933 
    gmaps true
    
    factory :new_organization do
      name "New Organization"
      active false
    end
    
    factory :crisis_organization do
      name "Crisis Organization"
      crises { [Factory(:crisis)] }
    end
    
  end
  
end
