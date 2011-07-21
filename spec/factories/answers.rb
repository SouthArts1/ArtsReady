# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :answer do |f|
  f.question { Factory(:question) }
  f.assessment { Factory(:assessment) }
  f.critical_function 'test'
end