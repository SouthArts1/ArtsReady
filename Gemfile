source 'http://rubygems.org'

ruby '2.4.9'

gem 'rake', '< 11.0' # until we upgrade rspec-core or maybe cucumber

gem 'rails', '~> 4.2.11'
gem 'mysql2', '~> 0.5.3'
gem 'jquery-rails', '~> 2.1.4'
gem 'coffee-rails'
gem 'sassc-rails'

gem 'figaro'

gem 'bcrypt', '3.1.13'
gem 'cancan', '1.6.7'

gem 'carrierwave', '~> 1.3'
gem 'fog'
gem 'xmlrpc'

gem 'geocoder', '~> 1.1.6'
gem 'gmaps4rails', '1.5.7'

gem 'csv_builder'
gem 'RedCloth'
gem 'mustache'
gem 'acts-as-taggable-on', '~> 3.5.0'
gem 'simple_form', '~> 3.0'
gem 'protected_attributes'

gem 'airbrake'
gem 'newrelic_rpm'
gem 'awesome_print'

gem 'gibbon', '0.3.0'
gem 'restforce'
gem 'activerecord-import', '~> 1.0.2'

gem 'rack-ssl', :require => 'rack/ssl'
gem 'delayed_job_active_record', '~> 4.0.0'
gem 'delayed_job', '~> 4.0'

gem 'authorizenet'

# Production dependencies. Keeping these in the default gem group so
# we'll automatically keep them compatible while developing.
gem 'thin'
gem 'foreman'

group :test, :development do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'rb-fsevent'
  gem 'ruby_gntp'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-bundler'
  gem 'guard-pow'
  gem 'forgery'
  #gem 'ruby-debug-base19x', :require => 'ruby-debug'
end

group :development do
  gem 'puma'
  gem 'rails-footnotes', '~> 4.1'
  gem "binding_of_caller"
  gem 'better_errors'
end

group :test do
  gem 'mocha', :require => 'mocha/api'
  gem 'factory_girl', '~> 3.0'
  gem 'factory_girl_rails', '~> 3.0'
  gem 'database_cleaner', :require => false
  gem 'launchy'    # So you can do Then show me the page
  gem 'cucumber-rails', require: false
  gem 'cucumber', '~> 2.4.0', require: false
  gem 'minitest'
  gem 'test-unit', '~> 3.3.4'
  gem 'capybara', '~> 2.18'
  gem 'selenium-webdriver'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'shoulda'
  gem 'timecop'
  gem 'simplecov', require: false
  gem 'kelp'
  gem 'email_spec', '~> 2.2.0'
  gem 'webmock', '~> 2.3.1'
  gem 'vcr'
end

group :production, :staging do
  gem 'rails_12factor'
end
