class PaymentVariable < ActiveRecord::Base
  def self.float_value(key)
    find_by_key(key).value.to_f
  end
end
