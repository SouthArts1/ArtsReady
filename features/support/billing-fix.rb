if ENV['ANET_TRANSACTION_KEY'].blank?
  puts "Set ANET environment variables before running tests!"
  Cucumber.wants_to_quit = true
end

Before do
  load 'db/setup_payment_integration_data.rb'
end

After do
  Payment.find_each(&:cancel_subscription)
end
