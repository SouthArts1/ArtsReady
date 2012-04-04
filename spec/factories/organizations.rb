FactoryGirl.define do

  factory :organization do
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
      assessment_usage nil
      to_do_usage nil
    end

    after_build do |org, evaluator|
      if evaluator.member_count
        org.users << FactoryGirl.build_list(
          :member, evaluator.member_count.to_i,
          :organization => org)
      end

      if evaluator.assessment_usage
        done, total = evaluator.assessment_usage.split('/').map(&:to_i)
        org.assessment = Factory.build(:assessment,
          :organization => nil,
          :answers_count => total,
          :completed_answers_count => done)
      end

      if evaluator.to_do_usage
        done, total = evaluator.to_do_usage.split('/').map(&:to_i)
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
    
  end
  
end
