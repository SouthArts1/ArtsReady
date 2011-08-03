FactoryGirl.define do

  factory :article, :aliases => [:article_with_body] do
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
    
    factory :article_with_link do
      link "http://www.test.host"
    end
    
    factory :article_with_file do
    end
    
  end

end