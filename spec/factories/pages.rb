# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title "Title"
    body "Some body"
    slug "test"
  end
end