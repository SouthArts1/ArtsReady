# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :todo do |f|
  f.action_item_id 1
  f.answer_id 1
  f.user_id 1
  f.critical_function 'test'
  f.due_on "2011-06-16"
  f.description "MyString"
  f.priority "critical"
  f.complete false
end