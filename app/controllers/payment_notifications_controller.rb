class PaymentNotificationsController < ApplicationController
  skip_before_filter :authenticate!

  def create
    notification = PaymentNotification.create(
      params: params.select { |key, _| key =~ /^x_/ }
    )

    render(nothing: true)

    PaymentFromNotificationFactory.process(notification)
  end
end
