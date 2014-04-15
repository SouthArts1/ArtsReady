class BillingFormTestPage
  attr_accessor :world

  def initialize(world)
    self.world = world
  end

  def fill_out
    world.fill_in_fields(
      'Billing first name' => 'Bill',
      'Billing last name' => 'Lastname',
      'Billing address' => '100 Test St',
      'Billing city' => 'New York',
      'Billing state' => 'NY',
      'Billing zip code' => '10001',
      'Billing email' => 'billing@example.com',
      'Billing phone number' => '555-555-1212',
      'payment_type' => 'Credit Card',
      'subscription_number' => '4007000000027',
      'subscription_expiry_month' => '1',
      'subscription_expiry_year' => (Time.now.year + 3).to_s,
      'subscription_ccv' => '888')

    self
  end

  def enter_payment(method)
    world.fill_in_fields(method.fields)

    self
  end

  def submit
    world.press 'Submit Payment'

    self
  end

  def self.payment_method(name, overrides = {})
    payment_method_class(name).new(overrides)
  end

  def self.payment_method_class(name)
    {
      'checking account' => CheckingAccountPaymentMethod,
      'savings account'  => SavingsAccountPaymentMethod,
      'credit card'      => CreditCardPaymentMethod
    }.fetch(name)
  end

  class PaymentMethod
    attr_accessor :overrides

    def initialize(overrides)
      self.overrides = overrides
    end

    def fields
      default_fields.merge(overrides)
    end
  end

  class CreditCardPaymentMethod < PaymentMethod
    def default_fields
      {
        'payment_type'         => 'Credit Card',
        'subscription_number'       => '4007000000027',
        'subscription_expiry_month' => '1',
        'subscription_expiry_year'  => (Time.now.year + 3).to_s,
        'subscription_ccv'          => '888'
      }
    end
  end

  class BankAccountPaymentMethod < PaymentMethod
    def default_fields
      {
        'payment_type'           => 'Bank Account',
        'subscription_bank_name'      => 'First Bank of Nowheresville',
        'subscription_account_type'   => account_type,
        'subscription_routing_number' => '061092387',
        'subscription_account_number' => '123456789'
      }
    end
  end

  class CheckingAccountPaymentMethod < BankAccountPaymentMethod
    def account_type
      'Checking'
    end
  end

  class SavingsAccountPaymentMethod < BankAccountPaymentMethod
    def account_type
      'Savings'
    end
  end
end

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
  BillingFormTestPage.new(self).
    fill_out.
    submit
end

When(/^I update my subscription$/) do
  visit dashboard_path
  click_on 'Visit Billing'
  click_on 'Update Billing/Payment Information'

  fill_in 'Billing email', with: 'update@test.host'

  BillingFormTestPage.new(self).
    enter_payment(
      BillingFormTestPage.payment_method('credit card',
        'subscription_expiry_month' => 5,
        'subscription_expiry_year' => (Time.now.year + 4).to_s,
        'subscription_ccv' => '222'
      )
    ).submit
end

When /^I change my payment method to a credit card$/ do
  visit dashboard_path
  click_on 'Visit Billing'
  click_on 'Update Billing/Payment Information'

  BillingFormTestPage.new(self).
    enter_payment(BillingFormTestPage.payment_method('credit card')).
    submit
end

Then(/^my billing info should be saved$/) do
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
  email, password = ['newuser@test.host', 'password']

  visit sign_up_path

  fill_in 'Name', with: 'My Org'
  fill_in 'Address', with: '100 Test St'
  fill_in_fields(
    'City' => 'New York',
    'State' => 'NY',
    'Zipcode' => '10001',
    'First Name' => 'New',
    'Last Name' => 'User',
    'Email' => email
  )
  fill_in 'Password', with: password
  fill_in 'Confirm Password', with: password
  select '02 Organization - Non-profit', from: 'Organizational Status *'
  check 'terms'

  click_button 'Create Organization'

  expect(current_path).to eq(new_billing_path)

  remember_sign_in_credentials(email, password)
end

When(/^I sign up and pay$/) do
  step %{I sign up}
  step %{I fill out and submit the billing form}
end

When(/^I sign up and pay with a (checking account)$/) do |payment|
  step %{I sign up}

  BillingFormTestPage.new(self).
    fill_out.
    enter_payment(BillingFormTestPage.payment_method(payment)).
    submit
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

Then /^my billing info should show payment by credit card$/ do
  visit billing_path

  expect(page).to have_content 'Credit Card ending in 0027'
end

When /^I cancel my subscription$/ do
  visit billing_path
  click_on 'Update Billing/Payment Information'
  click_on 'I would like to cancel my automated billing entirely.'

  expect(page).
    to have_content 'successfully cancelled your subscription'
end