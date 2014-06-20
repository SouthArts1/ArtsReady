
Then(/^the organization should be added to Salesforce$/) do
  org = Organization.last

  account = SalesforceClient.new.find_account(org)

  expect(account.Name).to eq(org.name)
  expect(account.BillingStreet).to eq(org.billing_address)
  expect(account.BillingState).to eq(org.billing_state)
  expect(account.Next_Billing_Amount__c).
    to eq(PaymentVariable.float_value('starting_amount_in_cents') / 100)
  expect(Date.parse(account.First_Billing_Date__c)).to eq(Time.zone.today + 1)
end

When(/^the organization is updated$/) do
  click_on 'Settings'
  click_on 'Organization'
  fill_in 'Organization Name', with: 'New Name'
  fill_in 'Contact name', with: 'Thomas J. Flory, Esq.'
  click_on 'Save Settings'

  expect(page).to have_content 'updated'
end

Then(/^Salesforce should be updated$/) do
  org = Organization.last

  account = SalesforceClient.new.find_account(org)

  expect(account.Name).to eq('New Name')
  expect(account.Primary_Contact_First_Name__c).to eq('Thomas J.')
  expect(account.Primary_Contact_Last_Name__c).to eq('Flory')
end

When(/^the organization's billing info is updated$/) do
  FactoryGirl.create(:discount_code, discount_code: 'DISCO')

  click_on 'Settings'
  click_on 'Billing'
  click_on 'Update Billing/Payment Information'

  BillingFormTestPage.new(self).
    fill_out(
      'Billing city' => 'New Billing City',
      'Billing first name' => 'Jose'
    ).
    submit

  expect(page).to have_content 'Account status: Active'
end

Then(/^Salesforce billing info should be updated$/) do
  org = Organization.last

  account = SalesforceClient.new.find_account(org)

  expect(account.BillingCity).to eq('New Billing City')
  expect(account.Billing_First_Name__c).to eq('Jose')
end


When(/^the organization is charged$/) do
  org = Organization.last

  account = SalesforceClient.new.find_account(org)

  # make sure amount paid is blank, so that when we later test
  # that it isn't blank, we know that it's a result of the
  # payment notification
  expect(account.Amount_Paid__c).to be_blank

  receive_payment_notification_for(Organization.last.active_subscription)
end

Then(/^Salesforce payment info should be updated$/) do
  org = Organization.last

  account = SalesforceClient.new.find_account(org)

  expect(account.Amount_Paid__c).
    to eq(PaymentVariable.float_value('starting_amount_in_cents') / 100)
end