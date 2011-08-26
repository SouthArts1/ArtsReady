class Message < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :user
  
  validates_presence_of :content
  validates_presence_of :visibility
  
  scope :publically_visible, order('created_at DESC')
  
  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :name, :to => :organization, :allow_nil => true, :prefix => true
  
  def self.for_organization(org)
    publically_visible
  end

end