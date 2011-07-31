# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.first_name "First"
  f.last_name "Last"
  f.sequence(:email) {|n| "person#{n}@example.com" }
  f.password "password"
  f.password_confirmation {|p| p.password}
  f.role 'reader'
  f.admin false
  f.organization Factory(:organization)
end

Factory.define :reader, :parent => :user do |f|
end

Factory.define :manager, :parent => :user do |f|
  f.role 'manager'
end

Factory.define :editor, :parent => :user do |f|
  f.role 'editor'
end

Factory.define :executive, :parent => :user do |f|
  f.role 'executive'
end

Factory.define :new_user, :parent => :user do |f|
  f.organization Factory(:new_organization)
end

Factory.define :disabled_user, :parent => :user do |f|
  f.disabled true
end

Factory.define :crisis_user, :parent => :user do |f|
  f.organization Factory(:crisis_organization)
end

Factory.define :sysadmin, :parent => :user do |f|
  f.admin true
end