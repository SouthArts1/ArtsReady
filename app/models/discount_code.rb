class DiscountCode < ActiveRecord::Base
  has_many :subscriptions

  validates_numericality_of :redemption_max
  validates_presence_of :active_on, :expires_on

  # The database schema says that a DiscountCode has a discount_code,
  # which is confusing, so we give it a different alias here.
  def identifier
    discount_code
  end

  def total_deduction
    if deduction_type == "percentage"
      deduction_value.to_s + "%"
    else
      "$" + deduction_value.to_s + " off"
    end
  end
  
  def is_valid?
    time_validity && usage_validity
  end
  
  def time_validity
    active_on < Time.now && expires_on > Time.now
  end
  
  def usage_validity
    (redemption_max == 0) || (subscriptions.count <= redemption_max)
  end

  def starting_deduction
    Deduction.new(deduction_type, deduction_value)
  end

  def recurring_deduction
    Deduction.new(recurring_deduction_type, recurring_deduction_value)
  end

  class Deduction
    attr_accessor :type, :value

    def initialize(type, value)
      self.type = type
      self.value = value
    end

    def apply_to(cents)
      if type == "percentage"
        cents.to_f * ((100 - value).to_f / 100)
      elsif type == "dollars"
        cents.to_f - (value * 100)
      else
        cents
      end
    end
  end
end
