class PaymentNotificationsController < ApplicationController
  skip_before_filter :authenticate!

  def create
    PaymentNotification.create(
      params: params.select { |key, _| key =~ /^x_/ }
    )

    render(nothing: true)
  end
end
