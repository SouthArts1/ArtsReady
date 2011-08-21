FactoryGirl.define do

  factory :crisis do
    description "MyText"
    resolution "MyText"
    organization { Factory(:organization) }
    user { Factory(:user) }
  end

end