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
