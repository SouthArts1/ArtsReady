Given /^a sysadmin$/ do
  email = 'admin@test.host'
  password = 'password'
  @current_user = Factory(:sysadmin, :email => email, :password => password)
  login(email,password)
end

Given /^I am a sysadmin with email "([^"]*)"$/ do |email|
  Factory(:sysadmin, :email => email)
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
