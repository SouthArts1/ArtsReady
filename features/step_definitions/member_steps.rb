Given /^a visitor$/ do
end

Given /^a member with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory.create(:user, :email => email, :password => password)
end

Given /^(?:I am signed in as )?a (paid )?(?:user|reader)$/ do |paid|
  #email = 'user@test.host'
  password = 'password'
  factory = paid.present? ? :paid_user : :user
  @current_user = Factory.create(factory, :password => password)

  login(@current_user.email,password)
end

Given /^an executive$/ do
  email = 'executive@test.host'
  password = 'password'
  @current_user = Factory.create(:executive, :email => email, :password => password)

  login(email,password)
end

Given /^(?:I (?:am|have) signed in as )?a manager$/ do
  email = 'manager@test.host'
  password = 'password'
  @current_user = Factory.create(:manager, :email => email, :password => password)

  login(email,password)
end

Given /^(?:I (?:am|have) signed in as )?an editor$/ do
  email = 'editor@test.host'
  password = 'password'
  @current_user = Factory.create(:editor, :email => email, :password => password)

  login(email,password)
end


Given /^a crisis (.*)$/ do |role|
  email = 'crisis_user@test.host'
  password = 'password'
  org = Factory.create(:organization, :name => 'Crisis Organization', :battle_buddy_enabled => true)
  user = Factory.create(role.to_sym, :email => email, :password => password, :organization => org)
  Factory.create(:crisis, :user => user, :organization => org )
  @current_user = user
  login(email,password)
end

Given /^I am a member of an unapproved organization with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory.create(:new_user, :email => email, :password => password)
end

Given /^I am signed in as "([^"]*)"$/ do |email|
  login(email)
end

Given /^"([^"]*)" has a user with a first name of "([^"]*)"$/ do |org, name|
  org = Organization.find_by_name(org)
  FactoryGirl.create(:user, :first_name => name, :organization => org)
end

