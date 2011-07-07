Given /^a visitor$/ do
end

Given /^a member with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:user, :email => email, :password => password)
end

Given /^an authenticated user$/ do
  email = 'user@test.host'
  password = 'password'

  Given %{a member with email "#{email}" and password "#{password}"}
  And %{I am on the sign_in page}
  And %{I fill in "email" with "#{email}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}

  # visit('/sign_in')
  # fill_in('email', :with => login)
  # fill_in('password', :with => password)
  # click_button('user_submit')
end

Given /^I am a member of an unapproved organization with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:new_user, :email => email, :password => password)
end
