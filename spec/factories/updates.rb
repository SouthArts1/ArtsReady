# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :update do |f|
  f.message "MyText"
  f.user_id 1
  f.crisis_id 1
  f.organization_id 1
end