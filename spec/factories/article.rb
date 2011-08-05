FactoryGirl.define do

  factory :article, :aliases => [:private_article,:article_with_body] do
    title 'My Article'
    description Forgery::LoremIpsum.sentence
    body Forgery::LoremIpsum.paragraphs(3)
    visibility 'private'
    
    factory :public_article do
      visibility 'public'
    end
    
    factory :featured_article do
      visibility 'public'
      featured true
    end

    factory :disabled_article do
      disabled true
    end
    
    factory :article_with_link do
      link "http://www.test.host"
    end
    
    factory :article_with_file do
    end
    
  end

end