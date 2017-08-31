source 'http://rubygems.org'

ruby '2.1.5'

gem 'rails', '~> 3.2.3'
gem 'mysql2', '~> 0.3.11'
gem 'jquery-rails'

gem 'figaro'

gem 'bcrypt-ruby', '2.1.4', :require => 'bcrypt'
gem 'cancan', '1.6.7'

gem 'carrierwave', '0.5.7'
gem 'fog'

gem 'geocoder'
gem 'gmaps4rails', '1.3.1'

gem 'csv_builder'
gem 'RedCloth'
gem 'mustache'
gem 'acts-as-taggable-on', '>= 2.2.2'
gem 'simple_form'
gem 'strong_parameters'

gem 'airbrake'
gem 'newrelic_rpm', '~> 3.5.5'
gem 'awesome_print'

gem 'gibbon', '0.3.0'
gem 'restforce'
gem 'activerecord-import', '~> 0.3.0'

gem 'rack-ssl', :require => 'rack/ssl'
gem 'delayed_job_active_record', '~> 0.4.4'
gem 'delayed_job', '~> 3.0.5'

gem 'authorizenet'

# Production dependencies. Keeping these in the default gem group so
# we'll automatically keep them compatible while developing.
gem 'thin'
gem 'foreman'

group :test, :development do
  gem 'rspec-rails'
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
  gem 'rails-footnotes', '>= 3.7'
  gem 'sass'
  gem "binding_of_caller"
  gem 'better_errors'
end

group :test do
  gem 'mocha', :require => 'mocha/api'
  gem 'factory_girl', '~> 2.5'
  gem 'factory_girl_rails'
  gem 'database_cleaner', :require => false
  gem 'launchy'    # So you can do Then show me the page
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'shoulda'
  gem 'timecop'
  gem 'simplecov', require: false
  gem 'kelp', github: 'eostrom/kelp', branch: 'capybara-2-1'
  gem 'email_spec'
  gem 'webmock'
  gem 'vcr'
end
