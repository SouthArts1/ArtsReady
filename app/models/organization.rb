class Organization < ActiveRecord::Base
  
  has_one :assessment

  has_many :articles
  has_many :todos
  has_many :users
  
  validates_presence_of :name, :address, :city, :state, :zipcode
  
  def assessment_in_progress?
    false
  end
  
  def assessment_completion
    0
  end
  
  def todo_completion
    0
  end
  
  def battle_buddy_enabled?
    true
  end
  
end
