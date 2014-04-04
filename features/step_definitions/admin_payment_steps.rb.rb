Then(/^I can add a payment for "([^"]*)"$/) do |org|
  FactoryGirl.create(:discount_code, discount_code: 'DISCO')

  click_on 'Manage Organizations'
  edit_organization(org)
  click_on 'Payment History'
  click_on 'Add a payment'

  # Use default date and time
  select 'DISCO', from: 'Discount code'
  fill_in 'Amount', with: '50'
  fill_in 'Authorize.Net transaction ID', with: '123456789'
  select 'Savings', from: 'Account type'
  fill_in 'Routing number', with: '061092387'
  fill_in 'Account number', with: '987654312'

  pending
  click_on 'Save'

  expect(current_path).to eq(admin_organization_payments_path(org))
  expect(page).to have_content('Savings account ending in 4312')
end