# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.first_name "First"
  f.last_name "Last"
  f.sequence(:email) {|n| "person#{n}@example.com" }
  f.password "password"
  f.password_confirmation {|p| p.password}
  f.active true
  f.organization Factory(:organization)
end

Factory.define :admin, :parent => :user do |f|
  f.admin true
end