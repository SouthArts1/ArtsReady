class Message < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :user
  
  validates_presence_of :content
  validates_presence_of :visibility
  
  def self.for_organization(org)
    #public
    all
  end

end