Given /^a visitor$/ do
end

Given /^a member with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:user, :email => email, :password => password)
end

Given /^a user$/ do
  email = 'user@test.host'
  password = 'password'
  @current_user = Factory(:user, :email => email, :password => password)

  And %{I am on the sign_in page}
  And %{I fill in "email" with "#{email}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}
end

Given /^an executive$/ do
  email = 'executive@test.host'
  password = 'password'
  @current_user = Factory(:executive, :email => email, :password => password)

  And %{I am on the sign_in page}
  And %{I fill in "email" with "#{email}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}
end

Given /^a manager$/ do
  email = 'manager@test.host'
  password = 'password'
  @current_user = Factory(:manager, :email => email, :password => password)

  And %{I am on the sign_in page}
  And %{I fill in "email" with "#{email}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}
end

Given /^a editor$/ do
  email = 'editor@test.host'
  password = 'password'
  @current_user = Factory(:editor, :email => email, :password => password)

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
