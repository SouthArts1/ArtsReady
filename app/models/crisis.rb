class Crisis < ActiveRecord::Base

  belongs_to :organization
  belongs_to :user
  has_many :needs
  has_many :updates

  accepts_nested_attributes_for :updates
  accepts_nested_attributes_for :needs

  scope :active, includes(:organization).where(:resolved_on => nil)

  scope :shared_with_the_community, active.where(:visibility => 'public')
  scope :shared_with_my_battle_buddy_network, lambda {|list| where("visibility = 'buddies' AND organization_id IN (?)",list)}
  scope :shared_privately, where(:visibility => 'private')

  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :name, :to => :organization, :allow_nil => true, :prefix => true

  validates_presence_of :user_id
  validates_presence_of :organization_id

  after_create :send_crisis_announcement
  
  def self.shared_with_me(org)
    crises = []
    Crisis.shared_privately.each do |c|
      logger.debug(c.inspect)
      logger.debug(c.buddy_list.include?(org.id.to_s))
      crises << c if c.buddy_list.include?(org.id.to_s)
    end
    crises
  end

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
      organization.battle_buddies.collect {|buddy| buddy.users} rescue []
    when 'private'
      User.where("organization_id IN (?)", buddy_list.split(',').collect{|b| b.to_i}) rescue []
    else
      User.admins
    end
  end

  
  private 
  
  def send_crisis_announcement
    logger.debug(self.inspect)
    crisis_participants.each {|user| puts CrisisNotifications.announcement(user,self).inspect }
  end

  def send_crisis_resolution
    crisis_participants.each {|user| CrisisNotifications.resolved(user,self).deliver }
  end

end