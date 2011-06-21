class Todo < ActiveRecord::Base
  belongs_to :organization
  belongs_to :answer
  belongs_to :action_item
  belongs_to :user
  
  delegate :recurrence, :to => :action_item, :allow_nil => true, :prefix => false
  delegate :name, :to => :user, :allow_nil => true, :prefix => true
end
