class PaymentNotification < ActiveRecord::Base
  belongs_to :payment

  attr_accessible :params, :state
  serialize :params

  delegate :organization, to: :subscription, allow_nil: true

  def capture?
    type =~ /CAPTURE/i
  end

  def success?
    response_code == '1'
  end

  def subscription
    Subscription.find_by_arb_id(subscription_id) if subscription_id
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

  # Authorize.Net sends an x_subscription_id parameter only for ARB
  # transactions, so we explicitly define a method that will exist
  # whether or not the parameter is defined.
  def subscription_id
    params['x_subscription_id']
  end

  # Authorize.Net sends an x_subscription_paynum parameter only for ARB
  # transactions, so we explicitly define a method that will exist
  # whether or not the parameter is defined.
  def subscription_paynum
    params['x_subscription_paynum']
  end

  # Explicitly define a method without x_MD5_Hash's capitalization.
  def md5_hash
    param(:x_MD5_Hash)
  end

  def authenticated?
    # NOTE: this method is accurate for ARB transactions (specifically
    # captures), but not for other transactions. For a non-ARB method, see
    # http://www.authorize.net/support/merchant/wwhelp/wwhimpl/js/html/wwhelp.htm#href=3_IntegrationSettings.html#1094478
    source = md5_hash_value + trans_id + amount
    computed = Digest::MD5.hexdigest(source)
    computed.upcase == md5_hash
  end

  attr_accessor :md5_hash_value

  def md5_hash_value
    @md5_hash_value || ANET_MD5_HASH_VALUE
  end

  private

  def param(key)
    params[key.to_s]
  end
end
