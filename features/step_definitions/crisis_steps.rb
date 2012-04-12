Given /^I (?:am|should) not in crisis mode$/ do
  step 'I should see "OFF" within "#distress-switch"'
end

Given /^I (?:am|should be) in crisis mode$/ do
  step 'I should see "ON" within "#distress-switch"'
end

And /^I have a Battle Buddy$/ do
  org = Factory.create(:organization)
  Factory.create(:battle_buddy_request,
    :organization => @current_user.organization,
    :battle_buddy => org,
    :accepted => true)
end

When /^I resolve a crisis$/ do
  click_button 'crisis-deactivate'
end

When /^I declare a crisis$/ do
  step 'I follow "Activate"'
  step 'I choose "crisis_visibility_public"'
  step 'I press "Declare Crisis"'
end
