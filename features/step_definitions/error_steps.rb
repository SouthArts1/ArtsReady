Then /^I should see error messages$/ do
  page.should have_css('div.error_messages')
end
