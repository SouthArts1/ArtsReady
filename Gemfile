source 'http://rubygems.org'

gem 'rails', '3.0.9'
gem 'mysql2', '0.2.6'

gem 'bcrypt-ruby', :require => 'bcrypt' 
gem 'carrierwave'
  
# deploy
gem 'newrelic_rpm'
gem 'capistrano'
gem 'hoptoad_notifier'

group :test, :development do
  gem 'rspec-rails'
  gem 'rb-fsevent'
  gem 'growl'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-bundler'
  gem 'guard-pow'
end

group :development do
  gem "nifty-generators"
  gem 'rails3-generators'
  gem 'awesome_print'
  gem 'hirb'
  gem 'console_update'
  gem 'rails-footnotes', '>= 3.7'
end

group :test do
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'shoulda'
end
gem "mocha", :group => :test
