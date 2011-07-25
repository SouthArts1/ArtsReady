Given /^I am a sysadmin$/ do
  Factory(:sysadmin)
end

Given /^I am a sysadmin with email "([^"]*)"$/ do |email|
  Factory(:sysadmin, :email => email)
end
