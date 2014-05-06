Then(/^I can edit the "([^"]*)" email template$/) do |template|
  click_on 'Manage Email Templates'
  click_on template

  subject = 'ArtsReady has received your renewal payment'
  body = 'Thanks for your payment.'

  fill_in 'Subject', with: subject
  fill_in 'Body', with: body

  click_on 'Save'

  # verify that it was saved
  click_on template
  expect(find_field('Subject').value).to eq subject
  expect(find_field('Body').value).to eq body
end