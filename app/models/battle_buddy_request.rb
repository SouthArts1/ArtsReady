class BattleBuddyRequest < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :battle_buddy, :class_name => 'Organization'

  scope :pending, where('accepted IS NULL')
  
  after_create :email_potential_buddy, :unless => "accepted?" #only email on the intial request, not the reciprocal one
  
  def accept!
    self.accepted = true
    # create a reciprocal relationship
    BattleBuddyRequest.create(:organization => battle_buddy, :battle_buddy => organization, :accepted => true)
  end
  
  private
  
  def email_potential_buddy
    battle_buddy.managers.each do |manager|
      OrganizationMailer.battle_buddy_invitation(manager,battle_buddy,organization).deliver
    end
    battle_buddy.editors.each do |editor|
      OrganizationMailer.battle_buddy_invitation(editor,battle_buddy,organization).deliver
    end
  end
  
end
