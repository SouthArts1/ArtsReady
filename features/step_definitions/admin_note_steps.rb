class AdminNotesFormTestPage < TestPage
  def fill_out(overrides = {})
    fields = {
      'Notes'                        => 'Some notes.'
    }.merge(overrides)

    world.fill_in_fields(fields)

    yield if block_given?

    self
  end

  def fill_out_payment(overrides = {})
    fields = {
      'Amount'                       => '50',
      'Authorize.Net transaction ID' => '123456789',
      'Account type'                 => 'Savings',
      'Routing number'               => '061092387',
      'Account number'               => '987654312'
    }.merge(overrides)

    fill_out(fields)
  end

  def submit
    world.click_on 'Save'
  end
end

Then(/^I can add a note for "([^"]*)"$/) do |org_name|
  Timecop.freeze(Time.zone.parse('March 20, 2024 3:18:01pm'))

  visit_admin_notes_for(org_name)
  click_on 'Add a note'

  AdminNotesFormTestPage.new(self).
    fill_out('Notes' => 'Note without payment.').
    submit

  expect(page).to have_content 'Saved new note'

  expected_table = Cucumber::Ast::Table.new([
    {
      'Date/Time'      => '03/20/24 3:18 PM',
      'Discount code'  => '',
      'Amount'         => '',
      'Transaction ID' => '',
      'Account type'   => '',
      'Account number' => '',
      'Routing number' => '',
      'Notes'          => 'Note without payment.'
    }
  ])

  payment_table.diff!(expected_table)
end