Then(/^I can edit the "([^"]*)" email template$/) do |template|
  click_on 'Manage Email Templates'
  click_on template

  subject = 'Your subscription will renew in {{days_left_until_rebill}} days'
  body = 'Please update your billing info by {{next_billing_date}}.'

  fill_in 'Subject', with: subject
  fill_in 'Body', with: body

  click_on 'Save'
end

Given(/^I can preview the "([^"]*)" email template$/) do |template|
  click_on template
  click_on 'Preview'

  date = (Time.zone.today + 30).to_s(:long)

  expect(page).
    to have_content 'Your subscription will renew in 30 days'
  expect(page).
    to have_content "Please update your billing info by #{date}."

  # Verify that we can edit and save from the preview page.
  new_subject = 'Your subscription will renew soon'

  click_on 'Edit'
  fill_in 'Subject', with: new_subject
  click_on 'Preview'

  expect(page).
    to have_content new_subject

  click_on 'Save'
  click_on template
  expect(find_field('Subject').value).to eq new_subject
end
