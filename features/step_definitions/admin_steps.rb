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
