# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.first_name "MyString"
  f.last_name "MyString"
  f.email "MyString"
  f.password "MyString"
  f.password_confirmation "MyString"
end