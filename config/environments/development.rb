Artsready::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { :host => 'artsready.dev' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
end

unless $rails_rake_task
  require 'ruby-debug'

  Debugger.settings[:autoeval] = true
  Debugger.settings[:autolist] = 1
  Debugger.settings[:reload_source_on_change] = true
  Debugger.start_remote
end

S3_UPLOAD_BUCKET = 'artsready-dev'
MAILCHIMP_API_KEY = '5f70b48cbd31f3cab0d4d24ca8d5acde-us2'
MAILCHIMP_LIST_ID = '91aa1b2d44'

# For Sandbox account erik@echographia.com
ANET_API_LOGIN_ID = "7932FsrFV"
ANET_TRANSACTION_KEY = "6Mn7b5HhAk5842pq"
ANET_MODE = :test
