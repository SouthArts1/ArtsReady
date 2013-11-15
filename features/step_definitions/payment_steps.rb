Given /^I have paid for my subscription$/ do
  visit new_billing_path
  step %{I fill out and submit the billing form}
  expect(current_path).to eq(dashboard_path)
end

Given /^I have renewed my subscription$/ do
  visit new_billing_path
  step %{I fill out and submit the billing form}
  expect(current_path).to eq(billing_my_organization_path)
end

When /^I fill out and submit the billing form$/ do
  fill_in_fields(
    'Billing first name' => 'Bill',
    'Billing last name' => 'Lastname',
    'Billing address' => '100 Test St',
    'Billing city' => 'New York',
    'Billing state' => 'NY',
    'Billing zip code' => '10001',
    'Billing email' => 'billing@example.com',
    'payment_type' => 'Credit Card',
    'payment_number' => '4007000000027',
    'payment_expiry_month' => '1',
    'payment_expiry_year_1i' => '2017',
    'payment_ccv' => '888')

  press 'Submit Payment'
end

Given /^a 50% discount code exists$/ do
  @discount_code = FactoryGirl.create(:discount_code,
    discount_code: 'HALF',
    deduction_value: 50, deduction_type: 'percentage',
    apply_to_first_year: true
  )
end

When /^I sign up using the discount code$/ do
  visit sign_up_path

  fill_in_fields(
    'Name' => 'My Org',
    'Address' => '100 Test St',
    'City' => 'New York',
    'State' => 'NY',
    'Zipcode' => '10001',
    'First Name' => 'New',
    'Last Name' => 'User',
    'Email' => 'newuser@test.host',
    'Password' => 'password',
    'Confirm Password' => 'password'
  )
  select '02 Organization - Non-profit', from: 'Organizational Status *'
  check 'terms'

  click_button 'Create Organization'

  expect(current_path).to eq(new_billing_path)
  expect(page.find('#starting_amount_display').text).to eq('$300.00'),
    "subscription prices have changed, please update tests"

  fill_in 'discount_code', with: 'HALF'
  click_button 'Apply my discount code!'
  
  #page.find '#applied', visible: true # wait for response
  page.find('#starting_amount_display', text: '$150.00')

  step %{I fill out and submit the billing form}
end
