class Organization < ActiveRecord::Base
  acts_as_gmappable
  geocoded_by :full_street_address

  has_one :assessment
  has_one :crisis, :conditions => ("resolved_on IS NULL") #TODO ensure there is only one, and maybe sort by latest date as a hack
  has_many :articles
  has_many :battle_buddy_requests
  has_many :battle_buddies, :through => :battle_buddy_requests, :conditions => ["battle_buddy_requests.accepted IS true"]
  has_many :battle_buddy_requests_received, :conditions => ["battle_buddy_requests.accepted IS NOT true"], :class_name => 'BattleBuddyRequest', :foreign_key => 'battle_buddy_id'
  has_many :battle_buddy_requests_sent, :conditions => ["battle_buddy_requests.accepted IS NOT true"], :class_name => 'BattleBuddyRequest'
  has_many :crises
  has_many :resources
  has_many :todos
  has_many :updates
  has_many :users

  accepts_nested_attributes_for :users

  validates_presence_of :name, :address, :city, :state, :zipcode

  after_validation :geocode, :if => lambda{ |obj| (obj.changed.include?("address") || obj.changed.include?("city") || obj.changed.include?("state") || obj.changed.include?("zipcode"))  }

  after_create :send_sign_up_email
  after_update :send_approval_email, :if => lambda{ |obj| (obj.changed.include?("active") && obj.active?)  }

  scope :approved, where(:active => true)
  scope :in_buddy_network, where(:battle_buddy_enabled => true)
  scope :to_approve, where(:active => false)
  scope :nearing_expiration, where('0=1')
  scope :in_crisis, includes(:crisis).where('crises.resolved_on IS NULL')
  
  delegate :is_complete?, :to => :assessment, :allow_nil => true, :prefix => true
  delegate :percentage_complete, :to => :assessment, :allow_nil => true, :prefix => true

  
  def full_street_address
    [address, city, state, zipcode].compact.join(', ')
  end

  def gmaps4rails_address
    full_street_address
  end

  def todo_completion
    0
  end

  def is_my_buddy?
    false
  end
  
  def battle_buddy_list
    battle_buddies.collect(&:id).uniq
  end

  def last_activity
    users.order('last_login_at DESC').first.last_activity
  end

  def declared_crisis?
    crises.where(:resolved_on => nil).count == 1 ? true : false
  end

  def last_activity_at
    users.order('created_at DESC').first.created_at
  end

  def todo_percentage_complete
    # number_to_percentage(((completed_answers_count.to_f / answers_count.to_f)*100),:precision => 0)
    ((todos.completed.count.to_f / todos.count.to_f)*100).to_i rescue 0
  end
  
  def is_approved?
    active
  end

  private 
   
  def send_sign_up_email
    logger.debug("Sending sign_up email for organization #{name}")
    OrganizationMailer.sign_up(self) rescue logger.debug("send sign_up email failed")
  end

  def send_approval_email
    logger.debug("Sending approval email for organization #{name}")
    OrganizationMailer.welcome(self) rescue logger.debug("send approval email failed")
  end

end