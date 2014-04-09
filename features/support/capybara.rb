Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
  config.default_wait_time = 4
end