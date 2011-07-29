Given /^a sysadmin$/ do
  email = 'admin@test.host'
  password = 'password'
  @current_user = Factory(:sysadmin, :email => email, :password => password)

  And %{I am on the sign_in page}
  And %{I fill in "email" with "#{email}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}
end

Given /^I am a sysadmin with email "([^"]*)"$/ do |email|
  Factory(:sysadmin, :email => email)
end
