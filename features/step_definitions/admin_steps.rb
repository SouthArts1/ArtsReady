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

Then /^I should be able to view the organization's billing info$/ do
  click_on 'Manage Organizations'
  click_on 'Edit'
  click_on 'Billing'

  expect(page).to have_content 'Test Organization'
  expect(page).to have_content 'Bill Lastname'
  expect(page).to have_content '100 Test St'
  expect(page).to have_content 'New York, NY 10001'
  expect(page).to have_content 'Credit Card'
  expect(page).to have_content 'Discount code: DISCO'
  # Authorize.net actually charges the card on the business day
  # after the user submits the payment form, so we follow their
  # lead.
  expect(page).to have_content "Date joined: March 20, 2024"

  expect(page).to have_link('DISCO',
    href: edit_admin_discount_code_path(DiscountCode.last))
  expect(page).to have_content 'Account status: Active'
end
