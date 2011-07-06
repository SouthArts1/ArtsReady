# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :action_item do |f|
  f.description Forgery::LoremIpsum.sentence
end