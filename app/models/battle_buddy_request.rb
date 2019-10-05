class BattleBuddyRequest < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :battle_buddy, :class_name => 'Organization'

  scope :pending, -> { where('accepted IS NULL') }
  
  after_create :email_potential_buddy, :unless => "accepted?" #only email on the intial request, not the reciprocal one
  before_destroy :email_spurned_buddy
  
  def find_reciprocal_request
    BattleBuddyRequest.where(:organization_id => battle_buddy, :battle_buddy_id => organization).first
  end

  def accept!
    self.update_attributes(:accepted => true) &&
      # create a reciprocal relationship
      BattleBuddyRequest.create(:organization => battle_buddy, :battle_buddy => organization, :accepted => true)
  end

  def reject!
    # destroy both ends of the reciprocal relationship
    destroy
    find_reciprocal_request.try(:destroy)
  end

  def can_be_deleted_by?(org)
    org = organization || battle_buddy
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

  def email_spurned_buddy
    battle_buddy.managers.each do |manager|
      OrganizationMailer.battle_buddy_dissolution(manager,battle_buddy,organization).deliver
    end
    battle_buddy.editors.each do |editor|
      OrganizationMailer.battle_buddy_dissolution(editor,battle_buddy,organization).deliver
    end
  end
end
