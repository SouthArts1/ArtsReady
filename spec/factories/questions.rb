# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :question do |f|
  f.description Forgery::LoremIpsum.sentence
  f.critical_function "test"
end