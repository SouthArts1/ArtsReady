Given /^I have started an assessment$/ do
  Factory.create(:assessment, :organization => @current_user.organization)
end

Given /^I have started an assessment with (.*)$/ do |critical_function|
  Factory.create(:assessment, :organization => @current_user.organization,
    Assessment.critical_function_attribute(critical_function) => true)
end

Given /^I have finished an assessment$/ do
  Factory.create(:completed_assessment, :organization => @current_user.organization)
end

When /^I answer "(.*)" with "(.*)"$/ do |question, answer|
  preparedness, priority = answer.split('/')
  within '.questions' do
    within :xpath, "//*[contains(@class, 'question') and contains(., '#{question}')]" do
      choose(preparedness)
      choose(priority)
      click_button('save answer')
    end
  end
end

