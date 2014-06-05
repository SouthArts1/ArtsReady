class PaymentFromNotificationFactory
  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def eligible?
    notification.success? &&
      notification.authenticated? &&
      notification.capture? &&
      subscription.present?
  end

  def self.process(notification)
    new(notification).process
  end

  def process
    if eligible?
      build_payment
      notification.update_attributes(state: 'processed')
    else
      notification.update_attributes(state: 'discarded')
    end
  end

  def build_payment
    notification.build_payment(
      notification: notification,
      subscription: subscription,
      transaction_id: notification.trans_id,
      discount_code: subscription.discount_code,
      amount: notification.amount,
      account_number: notification.account_number,
      account_type: account_type,
      subscription_event: SubscriptionEvent.new(
        happened_at: notification.created_at
      )
    )
  end

  def subscription
    @subscription ||= notification.subscription
  end

  def account_type
    case notification.payment_method
      when 'CC' then notification.card_type
      when 'ECHECK' then 'Bank'
      else raise "Unknown account type: #{notification.method}"
    end
  end
end