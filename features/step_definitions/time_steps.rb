When /^(an?|[\d]+) (.*) (?:(?:has|have) passed|pass(?:es))?$/ do |count, unit|
  time = (count == 'a' ? 1 : count.to_i).send(unit)
  Timecop.travel(time)
end

When /^the scheduled tasks have run$/ do    
  require "rake"
  @rake = Rake::Application.new
  Rake.application = @rake
  Artsready::Application.load_tasks
  @rake['cron'].execute   
end

Given(/^the date is (.*)$/) do |date|
  Timecop.travel(Date.parse(date))
end

Given /^the time is (.*) on (.*)$/ do |time, date|
  Timecop.travel(Time.zone.parse("#{date} #{time}"))
end

And(/^today is the first of the month$/) do
  Timecop.freeze((Time.zone.now + 1.month).beginning_of_month)
end