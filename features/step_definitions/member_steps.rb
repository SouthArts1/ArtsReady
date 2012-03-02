def login(email,password)
  visit(sign_in_path)
  fill_in 'email', with: email
  fill_in 'password', with: password
  click_on 'Sign In'
end

Given /^a visitor$/ do
end

Given /^a member with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:user, :email => email, :password => password)
end

Given /^a user$/ do
  email = 'user@test.host'
  password = 'password'
  @current_user = Factory(:user, :email => email, :password => password)

  login(email,password)
end

Given /^an executive$/ do
  email = 'executive@test.host'
  password = 'password'
  @current_user = Factory(:executive, :email => email, :password => password)

  login(email,password)
end

Given /^a manager$/ do
  email = 'manager@test.host'
  password = 'password'
  @current_user = Factory(:manager, :email => email, :password => password)

  login(email,password)
end

Given /^a editor$/ do
  email = 'editor@test.host'
  password = 'password'
  @current_user = Factory(:editor, :email => email, :password => password)

  login(email,password)
end


Given /^a crisis user$/ do
  email = 'crisis_user@test.host'
  password = 'password'
  org = Factory(:organization, :name => 'Crisis Organization', :battle_buddy_enabled => true)
  user = Factory(:user, :email => email, :password => password, :organization => org)
  Factory(:crisis, :user => user, :organization => org )
  @current_user = user
  login(email,password)
end

Given /^I am a member of an unapproved organization with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:new_user, :email => email, :password => password)
end