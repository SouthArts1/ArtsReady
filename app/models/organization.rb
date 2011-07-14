class Organization < ActiveRecord::Base
  acts_as_gmappable
  geocoded_by :full_street_address

  has_one :assessment
  has_one :crisis, :conditions => ("resolved_on IS NULL") #TODO ensure there is only one, and maybe sort by latest date as a hack
  has_many :articles
  has_many :crises
  has_many :resources
  has_many :todos
  has_many :users

  validates_presence_of :name, :address, :city, :state, :zipcode

  after_validation :geocode, :if => lambda{ |obj| (obj.changed.include?("address") || obj.changed.include?("city") || obj.changed.include?("state") || obj.changed.include?("zipcode"))  }

  scope :in_buddy_network, where(:battle_buddy_enabled => true)
  scope :to_approve, where(:active => false)

  def full_street_address
    [address, city, state, zipcode].compact.join(', ')
  end

  def gmaps4rails_address
    full_street_address
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

  def is_my_buddy?
    false
  end
  
  def declared_crisis?
    crises.where(:resolved_on => nil).count == 1 ? true : false
  end
  
end