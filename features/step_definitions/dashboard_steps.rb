Given /^a user with an urgent to do$/ do
  #email = 'user@test.host'
  password = 'password'
  @current_user = FactoryGirl.create(:user, :password => password)
  @todo = FactoryGirl.create(:todo, :user => @current_user)
  login(@current_user.email, password)
end

Then /^I should see urgent to dos area$/ do 
  page.should have_css('h3.icon-action')
end


