FactoryGirl.define do

  factory :answer do
    question { Factory(:question) }
    assessment { Factory(:assessment) }
    critical_function 'test'
  end

end