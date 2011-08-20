class Crisis < ActiveRecord::Base

  belongs_to :organization
  belongs_to :user
  has_many :needs
  has_many :updates

  accepts_nested_attributes_for :updates
  accepts_nested_attributes_for :needs

  scope :active, includes(:organization).where(:resolved_on => nil)
  scope :public, where(:visibility => 'public')
  scope :private, where(:visibility => 'private')
  scope :battle_buddy_network, where(:visibility => 'buddies')
  
  after_create :send_crisis_announcement
  
  def resolve_crisis!
    self.resolved_on= Time.now
    self.save
    send_crisis_resolution
  end

  def crisis_participants
    case visibility
    when 'public'
      User.all
    when 'buddies'
      organization.battle_buddies.collect {|buddy| buddy.users}
    when 'private'
      User.admins
    else
      User.admins
    end
  end

  
  private 
  
  def send_crisis_announcement
    users = self.crisis_participants
    users.each {|user| CrisisNotifications.announce(self,user).deliver }
  end

  def send_crisis_resolution
    users = self.crisis_participants
    users.each {|user| CrisisNotifications.resolved(self,user).deliver }
  end

end