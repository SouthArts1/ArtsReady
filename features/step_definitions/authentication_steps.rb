Given /^I sign in as "(.*)\/(.*)"$/ do |email, password|
 When %{I go to the sign in page}
 And %{I fill in "Email" with "#{email}"}
 And %{I fill in "Password" with "#{password}"}
 And %{I press "Sign In"}
end

When /^I sign out$/ do
 And %{I follow "Logout"}
end
 

When /^I return next time$/ do
  reset!
  And %{I go to the homepage}
end

Then /^I should be signed in$/ do
  Then %{I should see "Logout"}
end

Then /^I should be signed out$/ do
  Then %{I should see "Login"}
end

