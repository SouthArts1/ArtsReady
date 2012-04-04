FactoryGirl.define do

  factory :answer do
    question
    assessment
    critical_function 'test'
  end

end
