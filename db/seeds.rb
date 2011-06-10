# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

admin = User.create!(:email=>'admin@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Admin', :last_name => 'User', :admin => true)

org = Organization.create!(:name => 'Test Organization', :address => '1500 Broadway', :city => 'New York', :state => 'NY', :zipcode => '10001')
member = User.create!(:email=>'test@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Test', :last_name => 'User', :organization => org)

puts member.inspect

member.articles.create(:title => 'First Article', :content => 'This is my article')
member.articles.create(:title => 'Another article Article', :content => 'This is my article')

Article.all.each {|a| puts a.inspect}