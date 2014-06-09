Given /^I have paid for my subscription$/ do
  visit new_billing_path
  step %{I fill out and submit the billing form}
  expect(current_path).to eq(dashboard_path)

  receive_payment_notification_for(@current_user.active_subscription)
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

When(/^I update my subscription( and am rejected.*)?$/) do |rejected|
  visit dashboard_path
  click_on 'Visit Billing'
  click_on 'Update Billing/Payment Information'

  fill_in 'Billing email', with: 'update@test.host'

  credit_card_details = {
    'subscription_expiry_month' => 5,
    'subscription_expiry_year' => (Time.now.year + 4).to_s,
    'subscription_ccv' => '222'
  }

  if rejected
    credit_card_details[:subscription_number] = '4222222222222'
  end

  BillingFormTestPage.new(self).
    enter_payment(
      BillingFormTestPage.payment_method('credit card',
        credit_card_details
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

  billing_page = BillingInfoTestPage.new(self)
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

  SignUpFormTestPage.new(self)
    .fill_out(
      'Email' => email,
      'Password' => password
    )
    .submit

  expect(current_path).to eq(new_billing_path)
  @current_user = User.find_by_email(email)

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

When(/^I sign up and pay with invalid billing data$/) do
  step %{I sign up}

  BillingFormTestPage.new(self).
    fill_out('Billing first name' => '').
    submit
end

When /^I sign up and pay and am rejected by the payment gateway$/ do
  step %{I sign up}

  BillingFormTestPage.new(self).
    fill_out.
    enter_payment(
      BillingFormTestPage.payment_method('credit card',
        subscription_number: '4222222222222'
      )
    ).
    submit
end

Given(/^my credit card expires at the end of this month$/) do
  Timecop.freeze(Time.zone.parse('July 1, 2022'))

  step %{I sign up}

  BillingFormTestPage.new(self).
    fill_out(
      'subscription_expiry_month' => '7',
      'subscription_expiry_year' => '2022',
    ).
    submit
end

Then(/^the billing form is rejected(?: with the message "(.*)")?$/) do |message|
  expect(current_path).to eq(billing_path)
  expect(page).to have_content 'a problem processing your request'
  expect(page).to have_content message if message
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

When(/^I have (?:been charged|renewed) automatically$/) do
  receive_payment_notification_for(@current_user.active_subscription)
end

Then(/^my billing info should reflect automatic renewal$/) do
  visit billing_path

  expect(page).to have_content 'Date joined: March 19, 2024'
end

Then(/^my billing info should reflect manual renewal$/) do
  visit billing_path

  expect(page).to have_content 'Date joined: March 19, 2024'
  expect(page).to have_content 'update@test.host'
end

Then /^my billing info should show payment by credit card$/ do
  visit billing_path

  expect(page).to have_content 'Credit Card ending in 4444'
end

When /^I cancel my subscription$/ do
  visit billing_path
  click_on 'Update Billing/Payment Information'
  click_on 'I would like to cancel my automated billing entirely.'

  expect(page).
    to have_content 'successfully cancelled your subscription'
end

But(/^I can revive my cancelled subscription$/) do
  BillingFormTestPage.new(self)
    .fill_out
    .submit

  step %{I should be signed in}
end

And(/^I have let my subscription expire$/) do
  # At present, we don't automatically cancel subscriptions when they
  # expire. An admin might manually cancel a lapsed subscription, but
  # we don't want to sign out, sign in as an admin, find the organization,
  # cancel its billing, sign out, and try to sign back in as a user in
  # this integration test, so instead we simulate most of that by just
  # calling the `cancel` method directly.
  @current_user.organization.subscription.cancel
  @current_user.organization.update_attribute(:active, false)
end

Then(/^I can start a new subscription$/) do
  visit dashboard_path # redirects to billing page

  BillingFormTestPage.new(self)
    .fill_out
    .submit

  step %{I should be signed in}
end

Given(/^I have provisional access$/) do
  step %{I sign up}

  subscription = Organization.last.build_provisional_subscription
  subscription.save
  expect(subscription).to be_persisted

  visit billing_path
  expect(page).to have_content 'Provisional Access'
end

Then(/^I can switch to paid access$/) do
  old_subscription = Organization.last.subscriptions.first
  expect(old_subscription).to be_active

  step %{I update my subscription}

  visit billing_path
  expect(page).not_to have_content 'Provisional Access'

  old_subscription.reload
  expect(old_subscription).not_to be_active
end


Then(/^I should receive a (\d+)-day renewal reminder$/) do |days|
  days = Integer(days)
  address = BillingFormTestPage.default_billing_address

  open_email(address, with_subject: /will renew in #{days} days/)

  expect(current_email.body).to include (Time.zone.today + days).to_s(:long)
  expect(current_email.body).to include '<strong>Soon</strong>'
end

Then(/^I should receive a credit card expiration notice$/) do
  address = BillingFormTestPage.default_billing_address

  open_email(address, with_subject: /card will expire in 30 days/)

  expect(current_email.body).to include 'update'
  expect(current_email.body).
    to include 'July  2, 2023' # see "my credit card expires" step
end

And(/^my next billing date should be (.*)$/) do |date|
  click_on 'Settings'
  click_on 'Billing'

  expect(page).to have_content "Next billing date: #{date}"
end