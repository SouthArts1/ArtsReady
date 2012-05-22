# Assumptions:

* Ruby 1.9.2 (specific details in .rvmrc) installed
* MySQL 5.1 installed
* bundler installed

# Recommendations:

* rvm for ruby
* homebrew for mysql/etc

# Setting up the application

* CHECKOUT THE DEVELOP BRANCH IF YOU WANT LATEST CODE (eg git co develop)
* $>bundle to install gems
* Copy config/database.yml.template to config/database.yml and adjust as needed to access your MySQL db
* rake db:setup (create, migration, and load seed data)
* After seeding data, or when utilizing live data, utilize rails runner db/setup_payment_integration_data.rb to load payment vars and discount codes.

