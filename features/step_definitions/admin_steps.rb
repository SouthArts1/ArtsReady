Given /^(?:I am signed in as )?a sysadmin$/ do
  email = 'admin@test.host'
  password = 'password'
  @current_user = Factory.create(:sysadmin, :email => email, :password => password)
  login(email,password)
end

Given /^I am a sysadmin with email "([^"]*)"$/ do |email|
  Factory.create(:sysadmin, :email => email)
end

Given /^all users .* "(.*)" are disabled$/ do |org|
  Organization.find_by_name(org).users.
    update_all(:disabled => true)
end

When /^I view the admin article page for "([^"]*)"$/ do |title|
  article = Article.find_by_title(title)
  visit admin_articles_path(article)
end

Then /^I should see the following organizations:$/ do |table|
  table.diff!(
    [
      ['Name', 'Members', 'Assessment %', 'To-Do %'],
      *page.all('table.resource tbody tr').map do |tr|
        ['.name', '.members', '.assessment', '.todo'].map do |selector|
          tr.first(selector).try(:text).try(:strip)
        end
      end
    ]
  )
end

When /^I delete the organization "(.*)"$/ do |org|
  be_on 'the admin organizations page'
  edit_organization(org)

  click_button 'DELETE'
end

Then /^the organization "(.*)" should be deleted$/ do |name|
  be_on 'the admin organizations page'
  page.should_not have_content(name)
end


Then(/^the organization should be added to Salesforce$/) do
  org = Organization.last

  account = SalesforceClient.new.find_account(org)

  expect(account.Name).to eq(org.name)
end


Then(/^Salesforce should be updated$/) do
  org = Organization.last

  account = SalesforceClient.new.find_account(org)

  expect(account.Name).to eq('New Name')
end