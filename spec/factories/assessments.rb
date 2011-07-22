# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :assessment do |f|
  f.organization { Factory(:organization)}
end

Factory.define :completed_assessment, :parent => :assessment do |f|
  f.organization { Factory(:organization)}
  f.complete true
  f.answers_count 10
  f.completed_answers_count 10
end