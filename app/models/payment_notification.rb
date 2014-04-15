class PaymentNotification < ActiveRecord::Base
  belongs_to :payment

  attr_accessible :params
  serialize :params

  def param(key)
    params[key.to_s]
  end
end
