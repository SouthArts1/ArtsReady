Given /^I (?:am|should) not in crisis mode$/ do
  step 'I should see "OFF" within "#distress-switch"'
end

Given /^I (?:am|should be) in crisis mode$/ do
  step 'I should see "ON" within "#distress-switch"'
end

And /^I have a Battle Buddy(?: with a name of "(.*)")?$/i do |name|
  org = FactoryGirl.create(:organization, :name => name || "Default Org")
  FactoryGirl.create(:battle_buddy_request,
    :organization => @current_user.organization,
    :battle_buddy => org,
    :accepted => true)
  FactoryGirl.create(:battle_buddy_request,
    :organization => org,
    :battle_buddy => @current_user.organization,
    :accepted => true)
end

And /^I have a pending Battle Buddy request$/i do
  org = FactoryGirl.create(:organization)
  FactoryGirl.create(:battle_buddy_request,
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

Then /^the crisis has been announced$/ do
  step %{I should receive an email with subject "declared a crisis"}
end

Then /^the crisis resolution has been announced$/ do
  step %{I should receive an email with subject "resolved their crisis"}
end

When /^the crisis update has been announced$/ do
  step %{I should receive an email with subject "updated their crisis"}
end

