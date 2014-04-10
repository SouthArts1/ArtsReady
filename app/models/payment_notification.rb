class PaymentNotification < ActiveRecord::Base
  belongs_to :payment

  attr_accessible :params
  serialize :params
end
