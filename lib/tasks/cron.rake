desc "This task is called by the Heroku scheduler add-on"
task :cron => :environment do
  puts "Creating reassessment todos"
  Assessment.create_reassessment_todos
  puts "Sending billing notifications"
  Arbly::Checker.start

  if Time.zone.today.tuesday?
    puts "Sending todo reminders"
    Reminder.todos_nearly_due
  end

  # Temporarily disabled: https://www.pivotaltracker.com/story/show/70452188
  # if Time.zone.today.day == 1
  #   AdminMailer.renewing_organizations_notice.deliver
  #   AdminMailer.credit_card_expiring_organizations_notice.deliver
  # end

  Organization.send_renewal_reminders
  Organization.send_credit_card_expiration_notices

  puts "done."
end

