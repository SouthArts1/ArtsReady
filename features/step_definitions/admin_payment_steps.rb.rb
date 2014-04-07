Then(/^I can add a payment for "([^"]*)"$/) do |org_name|
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

  # exclude the footer row, since Cucumber::Ast::Table doesn't
  # understand it.
  rows = page.find('#payments').all('thead tr, tbody tr')
  table = rows.map do |row|
    row.all('td, th').map(&:text)
  end

  expected_table = Cucumber::Ast::Table.new([
    {
      'Discount code'  => 'DISCO',
      'Amount'         => '$50.00',
      'ARB ID'         => '123456789',
      'Account type'   => 'Savings',
      'Account number' => '4312',
      'Routing number' => '2387'
    }
  ])
  expected_table.diff!(table)
end