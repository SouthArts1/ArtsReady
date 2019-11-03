require 'capybara/rails'

Capybara.javascript_driver = :selenium_chrome_headless

Capybara.register_server :thin do |app, port, host|
  require 'rack/handler/thin'
  Rack::Handler::Thin.run(app, Host: host, Port: port)
end

Capybara.server = :thin
Capybara.always_include_port = true

Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
  config.default_wait_time = 4
end