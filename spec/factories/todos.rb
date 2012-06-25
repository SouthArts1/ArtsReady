FactoryGirl.define do

  factory :todo do
    critical_function 'test'
    due_on "2011-06-16"
    description "Urgent Todo"
    priority "critical"
    complete false
  end

end
