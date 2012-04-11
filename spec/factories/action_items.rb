FactoryGirl.define do

  factory :action_item do
    description Forgery::LoremIpsum.sentence
    question
  end

end
