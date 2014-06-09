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
