module BillingStepHelpers
  def receive_payment_notification_for(subscription, overrides = {})
    params = YAML.load(
      File.read(
        'features/fixtures/payment_notifications/auth_capture_1_1_CC.yml')
    ).with_indifferent_access

    params.merge!(stringify_params(overrides)).merge!(
      x_subscription_id: subscription.arb_id
    )

    post payment_notifications_path(params)
  end

  private

  # emulate params received from Authorize.Net, which are all strings
  def stringify_params(params)
    Hash[
      params.each_pair { |k, v| [k.to_s, v.to_s] }
    ]
  end
end

World(BillingStepHelpers)

if ENV['ANET_TRANSACTION_KEY'].blank?
  puts "Set ANET environment variables before running tests!"
  Cucumber.wants_to_quit = true
end

Before do
  load 'db/setup_payment_integration_data.rb'
end

After do
  Subscription.find_each(&:cancel)
end
