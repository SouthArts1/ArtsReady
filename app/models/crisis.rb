class Crisis < ActiveRecord::Base

  belongs_to :organization
  belongs_to :user
  has_many :needs
  has_many :updates

  accepts_nested_attributes_for :updates
  accepts_nested_attributes_for :needs

  scope :active, includes(:organization).where(:resolved_on => nil)

  scope :shared_with_the_community, active.where(:visibility => 'public')
  scope :shared_with_my_battle_buddy_network, lambda {|list| active.where("visibility = 'buddies' AND organization_id IN (?)",list)}
  scope :shared_privately, active.where(:visibility => 'private')
  scope :resolved, where( "resolved_on IS NOT NULL")

  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :name, :to => :organization, :allow_nil => true, :prefix => true

  validates_presence_of :user_id
  validates_presence_of :organization_id
  validates_presence_of :visibility
  validates_presence_of :buddy_list, :if => :private?
  
  # TODO validate buddy_list if permission is set to only my buddies

  after_create :send_crisis_announcement
  
  def self.shared_with_me(org)
    crises = []
    Crisis.shared_privately.each do |c|
      crises << c if c.buddy_list.split(',').include?(org.id.to_s) unless c.buddy_list.nil?
    end
    crises
  end

  def buddies
    case visibility
    when 'buddies'
      organization.battle_buddies
    when 'private'
      Organization.where(:id => buddy_list.split(',').map(&:to_i))
    else
      raise ArgumentError, "Don't know how to find buddies for #{visibility} crisis"
    end
  end

  def resolve_crisis!
    self.resolved_on= Time.now
    self.save
    send_crisis_resolution
  end

  def resolved?
    resolved_on.present?
  end
  
  def contacts_for_declaration
    case visibility
    when 'public'
      User.executives.active
    when 'buddies', 'private'
      User.in_organizations(buddies).executives
    else
      User.admins
    end
  end

  def contacts_for_update
    case visibility
    when 'buddies', 'private'
      User.in_organizations(buddies).executives
    else
      User.admins
    end
  end

  def contacts_for_resolution
    contacts_for_declaration
  end

  def private?
    visibility == 'private'
  end
  
  private 
  
  def send_crisis_announcement
    contacts_for_declaration.each {|u| CrisisNotifications.delay.announcement(u,self) }
  end

  def send_crisis_resolution
    contacts_for_resolution.each {|u| CrisisNotifications.delay.resolved(u,self) }
  end

end
