
RSpec.configure do |config|
  config.after(:each) do
    Payment.find_each(&:cancel_subscription)
  end
end

