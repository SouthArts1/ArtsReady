Then(/^I can add a payment for "([^"]*)"$/) do |org_name|
  Timecop.freeze(Time.zone.parse('March 20, 2024 3:18:01pm'))
  FactoryGirl.create(:discount_code, discount_code: 'DISCO')

  click_on 'Manage Organizations'
  edit_organization(org_name)
  click_on 'Payment History'
  click_on 'Add a payment'

  # Use default date and time
  select 'DISCO', from: 'Discount code'
  fill_in 'Amount', with: '50'
  fill_in 'Authorize.Net transaction ID', with: '123456789'
  select 'Savings', from: 'Account type'
  fill_in 'Routing number', with: '061092387'
  fill_in 'Account number', with: '987654312'

  click_on 'Save'

  expect(page).to have_content 'Saved new payment'

  expected_table = Cucumber::Ast::Table.new([
    {
      'Date/Time'      => '03/20/24 3:18 PM',
      'Discount code'  => 'DISCO',
      'Amount'         => '$50.00',
      'ARB ID'         => '123456789',
      'Account type'   => 'Savings',
      'Account number' => '4312',
      'Routing number' => '2387'
    }
  ])

  payment_table.diff!(expected_table)
end

And(/^I can edit the payment for "([^"]*)"$/) do |org_name|
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
      'ARB ID'         => '123456789',
      'Account type'   => 'Visa',
      'Account number' => '1001',
      'Routing number' => ''
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
  Timecop.freeze(Time.zone.parse('March 20, 2024 3:18:01pm'))

  subscription = Organization.find_by_name(org_name).subscription

  params = YAML.load(
    File.read(
      'features/fixtures/payment_notifications/auth_capture_1_1_CC.yml')
  ).with_indifferent_access

  params.merge!(
    x_subscription_id: subscription.arb_id
  )

  post payment_notifications_path(params)
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
      'ARB ID'         => '2052813',
      'Account type'   => 'American Express',
      'Account number' => '0002',
      'Routing number' => ''
    }
  ])

  expected_table.diff!(payment_table)
end