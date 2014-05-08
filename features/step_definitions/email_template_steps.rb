Then(/^I can edit the "([^"]*)" email template$/) do |template|
  click_on 'Manage Email Templates'
  click_on template

  subject = 'ArtsReady has received your renewal payment'
  body = 'Thanks for your payment of {{amount}}.'

  fill_in 'Subject', with: subject
  fill_in 'Body', with: body

  click_on 'Save'
end

Given(/^I can preview the "([^"]*)" email template$/) do |template|
  click_on template
  click_on 'Preview'

  expect(page).
    to have_content 'Subject: ArtsReady has received your renewal payment'
  expect(page).
    to have_content 'Thanks for your payment of $225.00.'

  # Verify that we can edit and save from the preview page.
  new_subject = 'Thanks for your ArtsReady renewal'

  click_on 'Edit'
  fill_in 'Subject', with: new_subject
  click_on 'Preview'

  expect(page).
    to have_content new_subject

  click_on 'Save'
  click_on 'renewal receipt'
  expect(find_field('Subject').value).to eq new_subject
end
