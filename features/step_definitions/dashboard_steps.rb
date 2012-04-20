Given /^a user with an urgent to do$/ do
  email = 'user@test.host'
  password = 'password'
  @current_user = Factory.create(:user, :email => email, :password => password)
  @todo = Factory.create(:todo, :user => @current_user)
end

Then /^I should see urgent to dos area$/ do 
  page.should have_css('h3.icon-action')
end


