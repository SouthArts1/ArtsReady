class AdminPaymentFormTestPage < TestPage
  def fill_out(overrides = {})
    fields = {
      'Amount'                       => '50',
      'Authorize.Net transaction ID' => '123456789',
      'Account type'                 => 'Savings',
      'Routing number'               => '061092387',
      'Account number'               => '987654312',
      'Notes'                        => 'Some notes.'
    }.merge(overrides)

    world.fill_in_fields(fields)

    yield if block_given?

    self
  end

  def submit
    world.click_on 'Save'
  end
end

Then(/^I can add a payment for "([^"]*)"$/) do |org_name|
  Timecop.freeze(Time.zone.parse('March 20, 2024 3:18:01pm'))
  FactoryGirl.create(:discount_code, discount_code: 'DISCO')

  click_on 'Manage Organizations'
  edit_organization(org_name)
  click_on 'Payment History'
  click_on 'Add a payment'

  AdminPaymentFormTestPage.new(self).
    fill_out('Discount code' => 'DISCO').
    submit

  expect(page).to have_content 'Saved new payment'

  expected_table = Cucumber::Ast::Table.new([
    {
      'Date/Time'      => '03/20/24 3:18 PM',
      'Discount code'  => 'DISCO',
      'Amount'         => '$50.00',
      'Transaction ID' => '123456789',
      'Account type'   => 'Savings',
      'Account number' => '4312',
      'Routing number' => '2387',
      'Notes'          => 'Some notes.'
    }
  ])

  payment_table.diff!(expected_table)
end

When(/^I add a payment by check for "([^"]*)"$/) do |org_name|
  Organization.find_by_name(org_name).
    update_column(:next_billing_date, Date.parse('March 20, 2024'))

  click_on 'Manage Organizations'
  edit_organization(org_name)
  click_on 'Payment History'
  click_on 'Add a payment'

  AdminPaymentFormTestPage.new(self).
    fill_out(
      'Authorize.Net transaction ID' => nil,
      'Account type' => 'Checking',
      'Check number' => '1001'
    ) do
      check 'Extend subscription to March 20, 2025?'
    end.
    submit

  expect(page).to have_content 'Saved new payment'

  click_on 'Edit'
  expect(find_field('Check number').value).to eq '1001'
end

Then(/^I can extend the next billing date for "([^"]*)" by 365 days$/) do |org_name_|
  click_on 'Billing'
  expect(page).to have_content 'Next billing date: March 20, 2025'
end

And(/^I can edit the payment for "([^"]*)"$/) do |org_name|
  click_on 'Payment History'
  click_on 'Edit'

  fill_in 'Payment date', with: '2024-03-19'
  fill_in 'Amount', with: '$75.00'
  select 'Visa', from: 'Account type'
  fill_in 'Account number', with: '8362352839281001'
  # TODO: clear/hide routing number when CC is selected

  click_on 'Save'

  expect(page).to have_content 'Updated payment'

  expected_table = Cucumber::Ast::Table.new([
    {
      'Date/Time'      => '03/19/24 3:18 PM',
      'Discount code'  => 'DISCO',
      'Amount'         => '$75.00',
      'Transaction ID' => '123456789',
      'Account type'   => 'Visa',
      'Account number' => '1001',
      'Routing number' => '',
      'Notes'          => 'Some notes.'
    }
  ])

  payment_table.diff!(expected_table)
end

And(/^I can delete the payment for "([^"]*)"$/) do |org_name|
  click_on 'Delete'

  expect(page).to have_content 'Deleted payment'

  # with no remaining payments, there's nothing to edit:
  expect(page).not_to have_button('Edit')
end

When(/^we receive automatic payment notifications for "([^"]*)"$/) do |org_name|
  organization = Organization.find_by_name(org_name)
  receive_payment_notification_for(organization.subscription)
end

Then(/^I can view the automatic payment details for "([^"]*)"$/) do |org_name|
  click_on 'Manage Organizations'
  edit_organization(org_name)
  click_on 'Payment History'

  expected_table = Cucumber::Ast::Table.new([
    {
      'Date/Time'      => '03/20/24 3:18 PM',
      'Discount code'  => '',
      'Amount'         => '$300.00',
      'Transaction ID' => '2210831157',
      'Account type'   => 'American Express',
      'Account number' => '0002',
      'Routing number' => ''
    }
  ])

  expected_table.diff!(payment_table)
end

Then /^I should be able to view the organization's billing info$/ do
  edit_last_organization
  click_on 'Billing'

  expect(page).to have_content 'Discount Organization'
  expect(page).to have_content 'Bill Lastname'
  expect(page).to have_content '100 Test St'
  expect(page).to have_content 'New York, NY 10001'
  expect(page).to have_content 'Credit Card'
  expect(page).to have_content 'Discount code: DISCO'
  expect(page).to have_content "Date joined: March 19, 2024"
  # Authorize.net actually charges the card on the business day
  # after the user submits the payment form, so we follow their
  # lead.
  expect(page).to have_content "Next billing date: March 20, 2024 (1 day)"

  expect(page).to have_link('DISCO',
    href: edit_admin_discount_code_path(DiscountCode.last))
  expect(page).to have_content 'Account status: Active'
end

Then(/^I can grant provisional access$/) do
  edit_last_organization
  click_on 'Billing'

  click_on 'Allow provisional access for 1 year'
  expect(page).to have_content 'Provisional access has been granted' # flash

  visit current_path
  expect(page).to have_content 'Provisional Access'
  expect(page).to have_content 'Next billing amount: $225.00'
end

Then(/^I can update the organization's subscription price$/) do
  edit_last_organization
  click_on 'Billing'
  arb_id = BillingInfoTestPage.new(self).arb_id
  click_on 'Edit Billing'

  fill_in 'Recurring amount', with: '223.52'
  click_on 'Update Subscription'

  expect(page).to have_content 'Next billing amount: $223.52'
  expect(BillingInfoTestPage.new(self).arb_id).to eq arb_id
end

Then(/^I can update the organization's next billing date$/) do
  Timecop.freeze(Date.parse('2023-11-11'))

  unless page.has_link? 'Edit Billing'
    edit_last_organization
    click_on 'Billing'
  end
  click_on 'Edit Billing'

  select '2024', from: 'subscription_organization_attributes_next_billing_date_1i'
  select 'March', from: 'subscription_organization_attributes_next_billing_date_2i'
  select '19', from: 'subscription_organization_attributes_next_billing_date_3i'
  click_on 'Update Subscription'

  expect(page).to have_content 'Next billing date: March 19, 2024'
end

And(/^the next billing date for "([^"]*)" is extended by (\d+) days$/) do |org_name, days|
  days = Integer(days)

  click_on 'Admin'
  click_on 'Manage Organizations'
  edit_organization(org_name)
  click_on 'Billing'

  page.text.match /Next billing date: (.*)/
  expect(Date.parse($1)).to eq(Date.today + days)
end

And(/^admins should receive an admin expiration notice for "([^"]*)"$/) do |org_name|
  notices = unread_emails_for('admin@artsready.org').select do |m|
    m.subject =~ /organization has expired/
  end

  expect(notices.count).to eq 1
  expect(notices.last.body).to include org_name
end

Then(/^admins should receive a renewing organizations notice for "(.*)"$/) do |org_name|
  message = find_email!('admin@artsready.org', with_subject: 'renewing soon')
  expect(message.body).to include org_name
end

And(/^admins should receive an expiring credit card admin notice for "([^"]*)"$/) do |org_name|
  message = find_email!('admin@artsready.org', with_subject: 'expiring soon')
  expect(message.body).to include org_name
end


And(/^admins should receive a failed payment form notification$/) do
  message = find_email!('admin@artsready.org', with_subject: 'ArtsReady payment submission error')

  expect(message.body).to include 'cannot be processed'
  expect(message.body).to include @current_user.email
  expect(message.body).to include @current_user.organization_name
  expect(message.body).to include(
    edit_admin_organization_url(@current_user.organization)
  )
  expect(message.body).to include('XXXXXXXXXXX')
end
