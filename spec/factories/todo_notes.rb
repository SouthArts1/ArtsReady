# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :todo_note do |f|
  f.todo_id 1
  f.user_id 1
  f.message "MyText"
end