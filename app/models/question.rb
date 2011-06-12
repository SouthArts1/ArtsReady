class Question < ActiveRecord::Base
  
  has_many :answers
  
  scope :by_critical_function, lambda {|cf| where(:critical_function => cf) }

end
