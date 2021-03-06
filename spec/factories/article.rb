FactoryGirl.define do

  factory :article, :aliases => [:private_article,:article_with_body] do
    title 'My Article'
    description Forgery::LoremIpsum.sentence
    body Forgery::LoremIpsum.paragraphs(3)
    visibility 'private'
    critical_function 'test'
    
    user
    organization { user.organization if user }

    factory :public_article do
      visibility 'public'
    end
    
    factory :shared_article do
      visibility 'shared'
    end

    factory :buddies_article do
      visibility 'buddies'
    end

    factory :featured_article do
      visibility 'public'
      featured true
    end

    factory :disabled_article do
      visibility 'public'
      disabled true
    end
    
    factory :article_with_link do
      link "http://www.test.host"
    end
    
    factory :article_with_file do
    end
    
  end

end
