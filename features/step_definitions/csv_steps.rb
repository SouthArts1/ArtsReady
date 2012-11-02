Then /^I should receive the following CSV:$/ do |table|
  # For some reason it seems like, in integration tests,something is
  # wrapping a bunch of HTML around our CSV. Unit tests and real browsers
  # confirm that there's no layout, so for now I'm just going to blame
  # Capybara.
  actual = CSV.parse(page.find('body *').text)

  # It's hard to get the updated_at field to match up in test and data,
  # and we really don't care, so just delete it.
  updated_col = actual.first.index('Updated')
  actual.each { |row| row.delete_at(updated_col) } if updated_col

  table.diff!(actual)
end

