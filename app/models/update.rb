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
    CrisisNotifications.update(user,self.crisis,self)
  end
  
end
