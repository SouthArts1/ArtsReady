class BattleBuddyRequest < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :battle_buddy, :class_name => 'Organization'

  scope :pending, where('accepted IS NULL')
  
  def accept!
    self.accepted = true
    # create a reciprocal relationship
    BattleBuddyRequest.create(:organization => battle_buddy, :battle_buddy => organization, :accepted => true)
  end
  
end
