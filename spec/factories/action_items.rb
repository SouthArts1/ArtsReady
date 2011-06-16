# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :action_item do |f|
  f.description "MyString"
  f.question_id ""
  f.import_id 1
  f.recurrence "MyString"
end