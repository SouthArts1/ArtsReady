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

Then /^I should receive the following CSV:$/ do |table|
  # For some reason it seems like, in integration tests,something is
  # wrapping a bunch of HTML around our CSV. Unit tests and real browsers
  # confirm that there's no layout, so for now I'm just going to blame
  # Capybara.
  actual = page.find('body *').text
  table.diff!(CSV.parse(actual))
end

