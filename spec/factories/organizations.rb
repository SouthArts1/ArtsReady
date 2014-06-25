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
      completed_answers_count nil
      to_do_usage nil
      renewing_in nil
    end

    after_build do |org, evaluator|
      if evaluator.member_count
        org.users << FactoryGirl.build_list(
          :member, evaluator.member_count.to_i,
          :organization => org)
      end

      if evaluator.renewing_in
        count, unit = evaluator.renewing_in.split(/\s+/)
        time = (count == 'a' ? 1 : count.to_i).send(unit)
        org.next_billing_date = Time.zone.today + time
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

    trait :unpaid do
      name 'Unpaid Organization'
      # no subscription, and
      active false
    end

    factory :unpaid_organization do
      unpaid
    end

    factory :provisional_organization do
      name 'Provisional Organization'
      member_count 1 # so the subscription can copy the user's info

      after_create do |org|
        org.subscriptions << FactoryGirl.build(:provisional_subscription)
      end
    end

    trait :paid do
      name 'Paid Organization'
      next_billing_date { ((created_at || Time.zone.now) + 1.day).to_date }

      ignore do
        subscription_factory :authorize_net_subscription
      end

      after_create do |org, evaluator|
        active = org.active
        next_billing_date = org.next_billing_date

        org.subscriptions << FactoryGirl.build(evaluator.subscription_factory)
        # Creating the subscription may change active and next billing date,
        # but we want to use the factory-set values, so we reset them here.
        org.update_column(:active, active)
        org.update_column(:next_billing_date, next_billing_date)
      end
    end

    factory :paid_organization do
      paid

      factory :expiring_organization do
        name 'Expiring Organization'
        subscription_factory :expiring_subscription
      end
    end

    trait :admin do
      # just to help us distinguish in tests
      name 'Admin Organization'
    end

    factory :admin_organization do
      admin

      factory :paid_admin_organization do
        paid
        admin # explicitly, so the name overrides 'paid'
      end
    end

    factory :paid_organization_with_discount_code do
      name 'Discount Organization'
      after_create do |org|
        org.subscriptions << FactoryGirl.build(:subscription_with_discount_code)
      end
    end
  end
  
end
