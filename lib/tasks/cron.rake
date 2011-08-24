desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "Sending reminders"
  Reminder.todos_nearly_due
  puts "done."
end