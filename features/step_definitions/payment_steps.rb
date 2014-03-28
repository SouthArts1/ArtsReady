class BillingInfoTestPage
  attr_accessor :page
  attr_accessor :missing_info

  def initialize(page)
    self.page = page
  end

  def missing_billing_info
    [
      'My Org',
      'Bill Lastname',
      '100 Test St',
      'New York, NY 10001',
      'Credit Card',
      '555-555-1212'
    ].select do |text|
      page.has_no_content?(text)
    end
  end
end

Given /^I have paid for my subscription$/ do
  visit new_billing_path
  step %{I fill out and submit the billing form}
  expect(current_path).to eq(dashboard_path)
end

Given /^I have renewed my subscription$/ do
  visit new_billing_path
  step %{I fill out and submit the billing form}
  expect(current_path).to eq(billing_path)
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
    'Billing phone number' => '555-555-1212',
    'payment_type' => 'Credit Card',
    'payment_number' => '4007000000027',
    'payment_expiry_month' => '1',
    'payment_expiry_year' => (Time.now.year + 3).to_s,
    'payment_ccv' => '888')

  press 'Submit Payment'
end

And(/^I update my subscription$/) do
  visit dashboard_path
  click_on 'Visit Billing'
  click_on 'Update Billing/Payment Information'

  select 'Credit Card', from: 'payment_type'
  fill_in_fields(
    'Billing email' => 'update@test.host',
    'payment_number' => '4007000000027',
    'payment_expiry_month' => '5',
    'payment_expiry_year' => (Time.now.year + 4).to_s,
    'payment_ccv' => '222'
  )

  press 'Submit Payment'
end

And(/^my billing info should be saved$/) do
  click_on 'Settings'
  click_on 'Billing'

  billing_page = BillingInfoTestPage.new(page)
  expect(billing_page.missing_billing_info).to eq []
end

Given /^a (\d+)% discount code exists$/ do |percentage|
  @discount_code = FactoryGirl.create(:discount_code,
    discount_code: 'PERCENT',
    deduction_value: percentage, deduction_type: 'percentage',
    recurring_deduction_value: percentage, recurring_deduction_type: 'percentage',
    apply_to_first_year: true, apply_to_post_first_year: true
  )
end

When /^I sign up$/ do
  visit sign_up_path

  fill_in 'Name', with: 'My Org'
  fill_in 'Address', with: '100 Test St'
  fill_in_fields(
    'City' => 'New York',
    'State' => 'NY',
    'Zipcode' => '10001',
    'First Name' => 'New',
    'Last Name' => 'User',
    'Email' => 'newuser@test.host',
  )
  fill_in 'Password', with: 'password'
  fill_in 'Confirm Password', with: 'password'
  select '02 Organization - Non-profit', from: 'Organizational Status *'
  check 'terms'

  click_button 'Create Organization'

  expect(current_path).to eq(new_billing_path)
end

When(/^I sign up and pay$/) do
  step %{I sign up}
  step %{I fill out and submit the billing form}
end

When /^I sign up using the discount code$/ do
  step %{I sign up}

  expect(page.find('#starting_amount_display').text).to eq('$300.00'),
    "subscription prices have changed, please update tests"

  fill_in 'discount_code', with: 'PERCENT'
  click_button 'Apply my discount code!'
  expect(page).to have_content :visible, 'code applied'

  step %{I fill out and submit the billing form}
end

Then(/^my billing info should reflect automatic renewal$/) do
  visit billing_path

  expect(page).to have_content 'Date joined: March 20, 2024'
end

Then(/^my billing info should reflect manual renewal$/) do
  visit billing_path

  expect(page).to have_content 'Date joined: March 20, 2024'
  expect(page).to have_content 'update@test.host'
end
