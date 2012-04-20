Then /^I should receive the following CSV:$/ do |table|
  # For some reason it seems like, in integration tests,something is
  # wrapping a bunch of HTML around our CSV. Unit tests and real browsers
  # confirm that there's no layout, so for now I'm just going to blame
  # Capybara.
  actual = page.find('body *').text
  table.diff!(CSV.parse(actual))
end

