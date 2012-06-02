FactoryGirl.define do

  factory :assessment do
    organization
    
    factory :completed_assessment do
      complete true
      completed_at { Time.now }

      after_create do |proxy|
        answers = proxy.answers
        last_answer = answers.last
        unless last_answer.blank?
          answers.pending.where(['id <> ?', last_answer]).update_all('was_skipped = true')
          last_answer.update_attributes(:preparedness => 'ready', :priority => 'critical')
        end
      end
    end
    
  end

end
