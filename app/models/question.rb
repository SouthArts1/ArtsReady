class Question < ActiveRecord::Base

  has_many :answers
  has_many :action_items

  scope :by_critical_function, lambda { |cf| where(:critical_function => cf) }
  scope :active, -> { where(:deleted => false) }

  validates_presence_of :description, :critical_function
end