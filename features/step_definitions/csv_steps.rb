Then /^I should receive the following CSV:$/ do |table|
  actual = CSV.parse(page.source)

  # It's hard to get the updated_at field to match up in test and data,
  # and we really don't care, so just delete it.
  updated_col = actual.first.index('Updated')
  actual.each { |row| row.delete_at(updated_col) } if updated_col

  table.diff!(actual)
end
