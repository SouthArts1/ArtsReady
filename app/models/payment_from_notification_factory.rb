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
      create_payment
    end
  end

  def create_payment
    notification.create_payment(
      subscription: subscription,
      paid_at: notification.created_at,
      transaction_id: notification.trans_id,
      discount_code: subscription.discount_code,
      amount: notification.amount,
      account_number: notification.account_number,
      account_type: account_type
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