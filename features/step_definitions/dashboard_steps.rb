Given /^I should see Urgent To-Dos$/ do 
  page.should have_css('h3.icon-action', :count => count.to_i)
end

Given /^user with an urgent todo$/ do
  email = 'user@test.host'
  password = 'password'
  @current_user = Factory(:user, :email => email, :password => password)
  @todo = Factory(:todo)
end


