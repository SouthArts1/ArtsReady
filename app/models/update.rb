class Update < ActiveRecord::Base
  belongs_to :crisis
  belongs_to :user
  belongs_to :organization

  validates_presence_of :crisis_id
  validates_presence_of :user_id
  validates_presence_of :organization_id
  validates_presence_of :message
  
  after_create :send_crisis_update_email
  
  def organization_name
    organization.name rescue 'Organization Name'
  end

  def user_name
    user.name rescue 'User Name'
  end
  
  private
  
  def send_crisis_update_email
    logger.debug("sending crisis update to #{crisis.contacts_for_update.inspect}")
    crisis.contacts_for_update.each { |user| 
      CrisisNotifications.latest_update(user,self.crisis,self).deliver_now
    }
  end
  
end
