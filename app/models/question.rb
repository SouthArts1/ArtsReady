class Question < ActiveRecord::Base
  
  scope :by_critical_function, lambda {|cf| where(:critical_function => cf) }

end
