When /^I am disbarred$/ do
  User.find_by_email('inactive@email.com').update_attribute(:disabled, true)
end

Then /^I cannot sign in$/ do
  visit sign_in_path
  follow 'Login'

  login('inactive@email.com', 'pass')

  page.should have_xpath(
    '//*', :text => 'has been disabled by an administrator'
  )
end

Given /^([^"]*) is deactivated$/ do |name|
  Organization.find_by_name(name).update_attribute(:active, false)
end

Given /^that (.*)(?:'|'s) organization has been deactivated$/ do |model|
  model = model.capitalize.constantize
  model.last.organization.update_attribute(:active, false)
end
