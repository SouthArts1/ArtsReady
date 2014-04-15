
RSpec.configure do |config|
  config.after(:each) do
    Subscription.find_each(&:cancel)
  end
end

