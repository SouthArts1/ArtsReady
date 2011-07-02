Given /^a member with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:user, :email => email, :password => password)
end

Given /^an authenticated user$/ do |email|
end

Given /^I am a member of an unapproved organization with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:new_user, :email => email, :password => password)
end
