Given /^I have started an assessment$/ do
  Factory(:assessment, :organization => @current_user.organization)
end

Given /^I have finished an assessment$/ do
  Factory(:completed_assessment, :organization => @current_user.organization)
end


