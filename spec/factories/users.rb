# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.first_name "First"
  f.last_name "Last"
  f.sequence(:email) {|n| "person#{n}@example.com" }
  f.password "password"
  f.password_confirmation {|p| p.password}
  f.active true
  f.role 'reader'
  f.admin false
  f.organization Factory(:organization)
end

Factory.define :owner, :parent => :user do |f|
  f.role 'owner'
end

Factory.define :new_user, :parent => :user do |f|
  f.organization Factory(:new_organization)
end

Factory.define :crisis_user, :parent => :user do |f|
  f.organization Factory(:crisis_organization)
end

Factory.define :sysadmin, :parent => :user do |f|
  f.admin true
end