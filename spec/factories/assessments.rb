FactoryGirl.define do

  factory :assessment do
    organization { Factory(:organization)}
    
    factory :completed_assessment do
      complete true
      answers_count 10
      completed_answers_count 10
    end
    
  end

end