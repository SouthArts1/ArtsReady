  Given /^a visitor$/ do
end

Given /^a member with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:user, :email => email, :password => password)
end

Given /^a user$/ do
  email = 'user@test.host'
  password = 'password'
  Factory(:user, :email => email, :password => password)

  And %{I am on the sign_in page}
  And %{I fill in "email" with "#{email}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}
end

Given /^a crisis user$/ do
  email = 'user@test.host'
  password = 'password'
  @crisis_user = Factory(:crisis_user, :email => email, :password => password)
  And %{I am on the sign_in page}
  And %{I fill in "email" with "#{email}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}
end

Given /^I am a member of an unapproved organization with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:new_user, :email => email, :password => password)
end
