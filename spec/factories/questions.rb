FactoryGirl.define do

  factory :question do
    description Forgery::LoremIpsum.sentence
    critical_function "people"
  end

  factory :active_question, :parent => :question do
    deleted false
  end
end