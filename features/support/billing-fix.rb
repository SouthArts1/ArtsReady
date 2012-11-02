Before do
  load 'db/setup_payment_integration_data.rb'
end

After do
  Payment.find_each(&:cancel_subscription)
end
