source 'http://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 3.2.3'
gem 'mysql2', '>= 0.3.11'
gem 'jquery-rails'

gem 'figaro'

gem 'bcrypt-ruby', '2.1.4', :require => 'bcrypt'
gem 'cancan', '1.6.7'

gem 'carrierwave', '0.5.7'
gem 'fog', '0.11.0'

gem 'geocoder'
gem 'gmaps4rails', '1.3.1'

gem 'csv_builder'
gem 'RedCloth'
gem 'acts-as-taggable-on', '>= 2.2.2'
gem 'simple_form'
gem 'strong_parameters'

gem 'heroku'
gem 'airbrake'
gem 'newrelic_rpm'

gem 'gibbon', '0.3.0'

gem 'rack-ssl', :require => 'rack/ssl'
gem 'delayed_job'

gem 'authorize-net', '1.5.2', :path => "vendor/gems/authorize-net-1.5.2"

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
end
