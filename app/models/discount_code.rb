class DiscountCode < ActiveRecord::Base
  has_many :subscriptions

  validates_numericality_of :redemption_max
  validates_presence_of :active_on, :expires_on

  def total_deduction
    if self.deduction_type == "percentage"
      str = self.deduction_value.to_s + "%"
    else
      str = "$" + self.deduction_value.to_s + " off"
    end
  end
  
  def is_valid?
    return true if self.time_validity && self.usage_validity
  end
  
  def time_validity
    return true if self.active_on < Time.now && self.expires_on > Time.now
    return false
  end
  
  def usage_validity
    return true if self.redemption_max == 0
    return true if self.subscriptions.count <= self.redemption_max
    return false
  end
end
