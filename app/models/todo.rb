class Todo < ActiveRecord::Base
  belongs_to :organization
  belongs_to :answer
  belongs_to :action_item
  
  delegate :description, :to => :action_item, :allow_nil => false, :prefix => false
end
