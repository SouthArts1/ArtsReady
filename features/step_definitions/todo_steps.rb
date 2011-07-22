Then /^I should see (\d+) todos$/ do |count|
  page.should have_css('td.item', :count => count.to_i)
end

Then /^I should not see any todos$/ do
  page.should_not have_css('item')
end

