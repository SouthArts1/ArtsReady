require 'rack/ssl'
Artsready::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  config.action_mailer.default_url_options = { :host => 'www.artsready.org' }

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
    
  config.middleware.insert_before ActionDispatch::Static, "Rack::SSL"
end

S3_UPLOAD_BUCKET = 'artsready-production'
MAILCHIMP_API_KEY = 'b8912933a59791689dcc41a2e5ebe34c-us2'
MAILCHIMP_LIST_ID = '5f443e1901'

# For Live A.Net Account
ANET_API_LOGIN_ID = ENV['ANET_API_LOGIN_ID'] || "2F3w8JFj3"
ANET_TRANSACTION_KEY = ENV['ANET_TRANSACTION_KEY'] || "88fbL6HwN759b2Mb"
ANET_MODE = :test