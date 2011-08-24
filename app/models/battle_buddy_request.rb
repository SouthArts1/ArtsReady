class BattleBuddyRequest < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :battle_buddy, :class_name => 'Organization'

  scope :pending, where('accepted IS NULL')
  
  after_create :email_potential_buddy, :if => "accepted.nil?" #only email on the intial request, not the reciprocal one
  
  def accept!
    self.accepted = true
    # create a reciprocal relationship
    BattleBuddyRequest.create(:organization => battle_buddy, :battle_buddy => organization, :accepted => true)
  end
  
  def email_potential_buddy
    
  end
  
end
