class Crisis < ActiveRecord::Base

  belongs_to :organization
  belongs_to :user
  has_many :needs
  has_many :updates

  accepts_nested_attributes_for :updates
  accepts_nested_attributes_for :needs

  scope :active, includes(:organization).where(:resolved_on => nil)
  scope :of_active_orgs, joins(:organization).merge(Organization.approved)

  scope :shared_with_the_community, active.where(:visibility => 'public')
  scope :shared_with_my_battle_buddy_network, lambda {|list| active.where("visibility = 'buddies' AND organization_id IN (?)",list)}
  scope :shared_privately, active.where(:visibility => 'private')
  scope :resolved, where( "resolved_on IS NOT NULL")

  delegate :name, :to => :user, :allow_nil => true, :prefix => true
  delegate :name, :to => :organization, :allow_nil => true, :prefix => true
  delegate :buddies, :to => :crisis_visibility

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

  def crisis_visibility
    case visibility
    when 'public'
      CrisisVisibility::Public.new(:organization => organization)
    when 'buddies'
      CrisisVisibility::Buddies.new(:organization => organization)
    when 'private'
      CrisisVisibility::Private.new(
        :organization => organization, :buddy_list => buddy_list)
    else
      raise ArgumentError, "Unknown visibility type: #{visibility}"
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
    orgs = crisis_visibility.organizations_for_declaration
    User.in_organizations(orgs, organization).executives.active
  end

  def contacts_for_update
    orgs = crisis_visibility.organizations_for_update
    User.in_organizations(orgs, organization).executives.active
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
