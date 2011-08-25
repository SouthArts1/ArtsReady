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
  scope :resolved, where( "resolved_on IS NOT NULL")

  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :name, :to => :organization, :allow_nil => true, :prefix => true

  validates_presence_of :user_id
  validates_presence_of :organization_id
  
  # TODO validate buddy_list if permission is set to only my buddies

  after_create :send_crisis_announcement
  
  def self.shared_with_me(org)
    crises = []
    Crisis.shared_privately.each do |c|
      crises << c if c.buddy_list.include?(org.id.to_s) unless c.buddy_list.nil?
    end
    crises
  end

  def resolve_crisis!
    self.resolved_on= Time.now
    self.save
    send_crisis_resolution
  end

  def resolved?
    resolved_on.present?
  end
  
  def crisis_participants
    case visibility
    when 'public'
      User.all
    when 'buddies'
      organization.battle_buddies.collect {|buddy| buddy.users} rescue []
    when 'private'
      User.where("organization_id IN (?)", buddy_list.split(',').collect{|b| b.to_i}) rescue [  ]
    else
      User.admins
    end
  end

  
  private 
  
  def send_crisis_announcement
    logger.debug(self.inspect)
    crisis_participants.each {|u| puts CrisisNotifications.announcement(u,self).deliver }
  end

  def send_crisis_resolution
    crisis_participants.each {|u| CrisisNotifications.resolved(u,self).deliver }
  end

end