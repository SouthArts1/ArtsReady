FactoryGirl.define do

  factory :answer do
    question
    assessment
    critical_function { question.critical_function }
  end

  factory :answered_answer, :parent => :answer do
    preparedness 'ready'
    priority 'critical'
  end
  
  factory :skipped_answer, :parent => :answer do
    was_skipped true
  end
  
  factory :pending_answer, :parent => :answer do
    preparedness nil
    priority nil
    was_skipped nil
  end
  
  factory :reconsidered_answer, :parent => :pending_answer do
    was_skipped false
  end
end
