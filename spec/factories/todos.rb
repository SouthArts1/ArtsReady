FactoryGirl.define do

  factory :todo do
    action_item_id 1
    answer_id 1
    critical_function 'test'
    due_on "2011-06-16"
    description "Urgent Todo"
    priority "critical"
    complete false
  end

end
