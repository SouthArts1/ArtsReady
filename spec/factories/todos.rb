# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :todo do |f|
  f.action_item_id 1
  f.answer_id 1
  f.due_on "2011-06-16"
  f.user_id 1
  f.note "MyString"
end