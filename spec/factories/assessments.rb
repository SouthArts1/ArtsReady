# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :assessment do |f|
  f.organization { Factory(:organization)}
end