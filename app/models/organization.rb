class Organization < ActiveRecord::Base
  
  has_one :assessment

  has_many :articles
  has_many :todos
  has_many :users
  
  validates_presence_of :name, :address, :city, :state, :zipcode
  
  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
    
  def full_street_address
    "#{address} #{city} #{state} #{zipcode}"
  end
  
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
