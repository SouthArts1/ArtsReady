When /^I fill out and submit the billing form$/ do
  fill_in_fields(
    'Billing first name' => 'Bill',
    'Billing last name' => 'Lastname',
    'Billing address' => '100 Test St',
    'Billing city' => 'New York',
    'Billing state' => 'NY',
    'Billing zip code' => '10001',
    'payment_type' => 'Credit Card',
    'payment_number' => '5415159924066154',
    'payment_expiry_month' => '1',
    'payment_expiry_year_1i' => '2017',
    'payment_ccv' => '888')

  press 'Create Payment'
end
