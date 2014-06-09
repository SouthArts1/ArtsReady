class SignUpFormTestPage < TestPage
  def fill_out(overrides = {})
    fields = {
      'Name' => 'My Org',
      'Address' => '100 Test St',
      'City' => 'New York',
      'State' => 'NY',
      'Zipcode' => '10001',
      'First Name' => 'New',
      'Last Name' => 'User',
      'Email' => 'email@example.org',
      'Password' => 'password',
      'Organizational Status *' => '02 Organization - Non-profit',
      'Terms' => true
    }.merge(overrides)

    # By default, confirm the password.
    fields['Confirm Password'] ||= fields['Password']

    # Fill in a few fields individually because their labels are ambiguous,
    # and `fill_in` is less fussy than `fill_in_fields`.
    %w(Name Address Password Confirm\ Password).each do |field|
      world.fill_in field, with: fields.delete(field)
    end

    # `fill_in_fields` doesn't seem to be able to find this checkbox.
    case fields.delete('Terms')
    when true then world.check 'Terms'
    when false then world.uncheck 'Terms'
    when nil then # do nothing
    end

    # Fill in the rest of the text inputs, plus selects.
    world.fill_in_fields(fields)

    self
  end

  def submit
    world.click_on 'Create Organization'

    self
  end
end
