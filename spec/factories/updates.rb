FactoryGirl.define do

  factory :update do
    message "MyText"
    user { Factory(:user) } 
    crisis { Factory(:crisis) } 
    organization { Factory(:organization) } 
  end

end