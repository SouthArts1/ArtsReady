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

  if Time.zone.today.day == 1
    AdminMailer.renewing_organizations_notice.deliver
    AdminMailer.credit_card_expiring_organizations_notice.deliver
  end

  Organization.send_renewal_reminders

  puts "done."
end

