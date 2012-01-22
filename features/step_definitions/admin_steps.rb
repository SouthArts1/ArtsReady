Given /^a sysadmin$/ do
  email = 'admin@test.host'
  password = 'password'
  @current_user = Factory(:sysadmin, :email => email, :password => password)
  login(email,password)
end

Given /^I am a sysadmin with email "([^"]*)"$/ do |email|
  Factory(:sysadmin, :email => email)
end
