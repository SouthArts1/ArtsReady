FactoryGirl.define do

  factory :question do
    description Forgery::LoremIpsum.sentence
    critical_function "test"
  end

end