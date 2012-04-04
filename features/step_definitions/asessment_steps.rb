Given /^I have started an assessment$/ do
  Factory.create(:assessment, :organization => @current_user.organization)
end

Given /^I have finished an assessment$/ do
  Factory.create(:completed_assessment, :organization => @current_user.organization)
end


