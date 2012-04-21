Given /^I (?:am|should) not in crisis mode$/ do
  step 'I should see "OFF" within "#distress-switch"'
end

Given /^I (?:am|should be) in crisis mode$/ do
  step 'I should see "ON" within "#distress-switch"'
end

And /^I have a Battle Buddy$/i do
  org = Factory.create(:organization)
  Factory.create(:battle_buddy_request,
    :organization => @current_user.organization,
    :battle_buddy => org,
    :accepted => true)
  Factory.create(:battle_buddy_request,
    :organization => org,
    :battle_buddy => @current_user.organization,
    :accepted => true)
end

And /^I have a pending Battle Buddy request$/i do
  org = Factory.create(:organization)
  Factory.create(:battle_buddy_request,
    :organization => org,
    :battle_buddy => @current_user.organization,
    :accepted => false)
end

And /^I should have no battle Buddies$/i do
  page.should have_content 'You have no Battle Buddies'
end

And /^I should have no pending battle buddy requests$/i do
  @current_user.organization.battle_buddy_requests.pending == nil
end

When /^I resolve a crisis$/ do
  click_button 'crisis-deactivate'
end

When /^I declare a crisis$/ do
  step 'I follow "Activate"'
  step 'I choose "crisis_visibility_public"'
  step 'I press "Declare Crisis"'
end
