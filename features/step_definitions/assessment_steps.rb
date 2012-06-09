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

When /^I finish the (?:re-)?assessment$/ do
  answers = @current_user.assessment.answers
  last_answer = answers.last
  answers.pending.where(['id <> ?', last_answer]).update_all('was_skipped = true')
  visit assessment_path(:tab => last_answer.critical_function)
  choose "critical"
  choose "needs work"
  click_button "save answer"
end

Given /^I have provided the following answers:$/ do |table|
  step "I have started an assessment"

  table.hashes.each do |human_hash|
    attributes = 
      convert_human_hash_to_attribute_hash(human_hash, 
        FactoryGirl.factory_by_name(:answer).associations)
    answer = @current_user.assessment.answers.
      find_by_question_id(attributes[:question].id)
    answer.attributes = attributes
    answer.was_skipped = attributes[:was_skipped]
    answer.save!
  end
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

When /^I answer the "(.*)" question$/ do |question|
  be_on assessment_path
  step %{I answer "#{question}" with "ready/critical"}
end

Then /^I should (?:get|have) a(?:nother)? re-assessment to-do$/ do
  visit path_to 'the todos page'
  page.should have_xpath('//tr', :text => 'Archive and Re-Assess', :count => 1)
  click_link 'Details'
  Date.parse(find_field('Due Date').value).should ==
    @current_user.assessment.reload.completed_at.to_date + 1.year
end

When /^I initiate a re-assessment$/ do
  click_link 'Assess'
  click_link 'Archive and Re-Assess'
end

When /^I start (?:the|a) re\-assessment$/ do
  be_on 'the new assessment page'
  click_button 'Begin Assessment'
end

Then /^the re-assessment sections should be based on the previous assessment$/ do
  pending # wait until we figure out how this UI should work
end

Then /^I should have (\d+) archived assessments?$/ do |count|
  click_link 'Settings'
  click_link 'Completed Assessments'
  page.should have_selector('table.assessments tbody tr', :count => count)
end

Then /^I should be able to view the archived assessments?$/ do
  be_on archived_assessments_path
  click_link 'View Assessment'
  assessment = @current_user.organization.assessments.complete.last
  current_path.should == archived_assessment_path(assessment, :format => :csv)
end

Then /^all "(.*)" questions should be skipped$/ do |cf|
  click_link cf
  page.all('.question:not(.not-applicable)').should be_empty
end
