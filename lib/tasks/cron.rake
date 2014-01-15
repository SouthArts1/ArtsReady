desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "Creating reassessment todos"
  Assessment.create_reassessment_todos
  puts "Sending billing notifications"
  Arbly::Checker.start

  if Date.today.tuesday?
    puts "Sending todo reminders"
    Reminder.todos_nearly_due
  end

  puts "done."
end

