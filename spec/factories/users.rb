FactoryGirl.define do

  factory :user, :aliases => [:reader, :member] do
    sequence(:email) {|n| "person#{n}@example.com" }
    title 'Director'
    first_name "First"
    last_name "Last"
    password "password"
    password_confirmation {|p| p.password}
    role 'reader'
    admin false
    accepted_terms true
    association :organization, :factory => :organization

    factory :editor do
      role 'editor'
    end

    factory :executive do
      role 'executive'
    end

    factory :manager do
      role 'manager'
    end

    factory :sysadmin do
      admin true
    end
  
    factory :disabled_user do
      disabled true
    end

    factory :new_user do
      association :organization, :factory => :new_organization
    end

    factory :crisis_user do
      association :organization, :factory => :crisis_organization
    end
  
  end

end