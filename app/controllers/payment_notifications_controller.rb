class PaymentNotificationsController < ApplicationController
  skip_before_filter :authenticate!

  def create
    notification = PaymentNotification.create(
      params: params.select { |key, _| key =~ /^x_/ }
    )

    render(nothing: true)

    subscription = Subscription.find_by_arb_id(
      notification.param(:x_subscription_id)
    )

    return if !subscription

    subscription.payments.create!(
      discount_code: subscription.discount_code,
      amount: notification.param(:x_amount),
      arb_id: subscription.arb_id,
      account_number: notification.param(:x_account_number),
      account_type: notification.param(:x_card_type)
    )
  end
end
