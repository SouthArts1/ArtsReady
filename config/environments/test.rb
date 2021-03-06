Artsready::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  config.action_controller.action_on_unpermitted_parameters = :raise

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  
  config.action_mailer.default_url_options = { :host => 'www.example.com' }
end

MAILCHIMP_API_KEY = 'not-required'
MAILCHIMP_LIST_ID = 'not-required'

ANET_API_LOGIN_ID = ENV['ANET_API_LOGIN_ID']
ANET_TRANSACTION_KEY = ENV['ANET_TRANSACTION_KEY']
ANET_MODE = :test
# When we run the tests, we pay for subscriptions repeatedly using
# the same info, and Authorize.net flags duplicate transactions.
# This setting reduces and may eliminate the pain.
ANET_ALLOW_DUPLICATE_TRANSACTIONS = true

ANET_MD5_HASH_VALUE = 'a hash value'
