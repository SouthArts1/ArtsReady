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

    trait :unpaid do
      name 'Unpaid Organization'
      # no subscription, and
      active false
    end

    factory :unpaid_organization do
      unpaid
    end

    trait :paid do
      name 'Paid Organization'
      next_billing_date { ((created_at || Time.zone.now) + 1.day).to_date }

      after_create do |org, evaluator|
        next_billing_date = org.next_billing_date
        org.subscriptions << FactoryGirl.build(:subscription)
        # Creating the subscription changes the next billing date, but we
        # want to use the factory-set value, so we reset it here.
        org.update_column(:next_billing_date, next_billing_date)
      end

      factory :renewing_organization do
        next_billing_date { Date.today + 1.month }

        after_create do |org, evaluator|
          # Creating the subscription in the parent factory changes the
          # next billing date, so we set it again here.
          org.update_column(:next_billing_date, evaluator.next_billing_date)
        end
      end
    end

    factory :paid_organization do
      paid

      factory :renewing_organization do
        name 'Renewing Organization'

        next_billing_date { Date.today + 1.month }

        after_create do |org, evaluator|
          org.update_column(:next_billing_date, evaluator.next_billing_date)
        end
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
