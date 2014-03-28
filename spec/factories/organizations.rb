FactoryGirl.define do

  factory :organization, aliases: [:unpaid_organization] do
    name "Test Organization"
    address "100 Test St"
    city "New York"
    state "NY"
    zipcode "10001"
    active true
    latitude 33.8039 
    longitude -84.3933 
    gmaps true
    organizational_status 'test'
    battle_buddy_enabled true
    
    ignore do
      member_count nil
      completed_answers_count nil
      to_do_usage nil
    end

    after_build do |org, evaluator|
      if evaluator.member_count
        org.users << FactoryGirl.build_list(
          :member, evaluator.member_count.to_i,
          :organization => org)
      end
    end

    after_create do |org, evaluator|
      answered = evaluator.completed_answers_count.to_i
      if answered > 0
        org.create_assessment unless org.assessment
        ids = org.assessment.answers.limit(answered).map(&:id)
        org.assessment.answers.where(:id => ids).update_all(
          :priority => 'critical', :preparedness => 'not ready')
      end

      if evaluator.to_do_usage
        done, total = evaluator.to_do_usage.split('/').map(&:to_i)
        org.todos.clear
        org.todos << FactoryGirl.build_list(:todo, done,
          :organization => nil, :complete => true)
        org.todos << FactoryGirl.build_list(:todo, total - done,
          :organization => nil, :complete => false)
      end
    end

    factory :new_organization do
      name "New Organization"
      active false
      battle_buddy_enabled false
    end
    
    factory :crisis_organization do
      name "Crisis Organization"
      crises
    end

    factory :paid_organization do
      after_create do |org|
        org.payments << FactoryGirl.build(:payment)
      end
    end

    factory :paid_organization_with_discount_code do
      after_create do |org|
        org.payments << FactoryGirl.build(:payment_with_discount_code)
      end
    end
  end
  
end
