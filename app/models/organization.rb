class Organization < ActiveRecord::Base
  acts_as_gmappable
  geocoded_by :full_street_address

  has_one :assessment

  has_many :articles
  has_many :todos
  has_many :users
  
  validates_presence_of :name, :address, :city, :state, :zipcode
  
  after_validation :geocode
    
  def full_street_address
    [address, city, state, zipcode].compact.join(', ')
  end

  def gmaps4rails_address
    [address, city, state, zipcode].compact.join(', ')
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
