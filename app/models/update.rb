class Update < ActiveRecord::Base
  belongs_to :crisis
  belongs_to :user
  belongs_to :organization

  after_create :send_crisis_update_email
  
  def organization_name
    organization.name rescue 'Organization Name'
  end

  def user_name
    user.name rescue 'User Name'
  end
  
  private
  
  def send_crisis_update_email
    logger.debug("sending crisis update to #{crisis.crisis_participants.inspect}")
    crisis.crisis_participants.each {|user| CrisisNotifications.latest_update(user,self.crisis,self).deliver }
  end
  
end
