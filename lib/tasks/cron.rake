desc "This task is called by the Heroku scheduler add-on"
task :cron => :environment do
  # puts "Creating reassessment todos"
  # Assessment.create_reassessment_todos
  # puts "Sending billing notifications"
  # Arbly::Checker.start

  # if Time.zone.today.tuesday?
  #   puts "Sending todo reminders"
  #   Reminder.todos_nearly_due
  # end

  if Time.zone.today.day == 1
    AdminMailer.renewing_organizations_notice.deliver_now
    AdminMailer.credit_card_expiring_organizations_notice.deliver_now
    # Organization.send_credit_card_expiration_notices
  end

  # Organization.send_renewal_reminders

  puts "done."
end

