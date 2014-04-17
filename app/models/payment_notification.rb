class PaymentNotification < ActiveRecord::Base
  belongs_to :payment

  attr_accessible :params
  serialize :params

  def capture?
    type =~ /CAPTURE/i
  end

  def success?
    response_code == '1'
  end

  def subscription
    Subscription.find_by_arb_id(subscription_id)
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

  def md5_hash
    param(:x_MD5_Hash)
  end

  def authenticated?
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
