Given /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  login(email,password)
end

When /^I sign out$/ do
 step 'I follow "Logout"'
end
 

When /^I return next time$/ do
  reset!
  step 'I go to the homepage'
end

Then /^I should be signed in$/ do
  step 'I should see "Logout"'
end

Then /^I should be signed out$/ do
  step 'I should see "Login"'
end

