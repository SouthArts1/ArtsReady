source 'http://rubygems.org'

gem 'rails', '~> 3.2.0'
gem 'mysql2', '~> 0.3.0'
gem 'jquery-rails'

gem 'bcrypt-ruby', '2.1.4', :require => 'bcrypt'
gem 'cancan', '1.6.7'

gem 'carrierwave', '0.5.7'
gem 'fog', '0.11.0'

gem 'geocoder'
gem 'gmaps4rails', '1.3.1'

gem 'csv_builder'
gem 'RedCloth'
gem 'acts-as-taggable-on'

gem 'heroku'
gem 'airbrake'

gem 'gibbon', '0.3.0'

gem 'rack-ssl', :require => 'rack/ssl'
gem 'delayed_job'

# Production dependencies. Keeping these in the default gem group so
# we'll automatically keep them compatible while developing.
gem 'thin'
gem 'newrelic_rpm'
gem 'foreman'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

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
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :development do
  gem 'rails-footnotes', '>= 3.7'
  gem 'sass'
end

group :test do
  gem 'mocha'
  gem 'factory_girl', '~> 2.5.1'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'launchy'    # So you can do Then show me the page
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'shoulda'
  gem 'simplecov'
end

