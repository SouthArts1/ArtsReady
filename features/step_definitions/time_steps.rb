When /^(an?|[\d]+) (.*) pass(?:es)?$/ do |count, unit|
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