class Organization < ActiveRecord::Base
  
  has_many :users
  has_many :articles
  has_one :assessment
  
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
  
end
