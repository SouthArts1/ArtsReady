class PaymentNotification < ActiveRecord::Base
  belongs_to :payment

  attr_accessible :params
  serialize :params

  def capture?
    param(:x_type) =~ /CAPTURE/i
  end

  def success?
    param(:x_response_code) == '1'
  end

  def subscription
    Subscription.find_by_arb_id(param(:x_subscription_id))
  end

  # Handle "notification.foo" by returning "params['x_foo']" if available.
  def method_missing(method_id, *arguments)
    if params.has_key?("x_#{method_id}")
      params["x_#{method_id}"]
    else
      super
    end
  end

  # Can't automatically generate `method` method because `BlankObject`
  # already defines one, so we provide an alias.
  def payment_method
    param(:x_method)
  end

  private

  def param(key)
    params[key.to_s]
  end
end
