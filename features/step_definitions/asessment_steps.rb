Given /^I have started an assessment$/ do
  Factory(:assessment, :organization => @current_user.organization)
end

