class Organization < ActiveRecord::Base
  acts_as_gmappable
  geocoded_by :full_street_address

  has_one :assessment, :dependent => :destroy
  has_one :crisis, :conditions => ("resolved_on IS NULL") #TODO ensure there is only one, and maybe sort by latest date as a hack
  has_many :articles
  has_many :public_articles, :class_name => 'Article',
    :conditions => "visibility = 'public'",
    :dependent => :nullify
  has_many :non_public_articles, :class_name => 'Article',
    :conditions => "visibility <> 'public'",
    :dependent => :destroy
  has_many :comments, :through => :articles
  has_many :battle_buddy_requests, :dependent => :destroy
  has_many :battle_buddies, :through => :battle_buddy_requests, :conditions => ["battle_buddy_requests.accepted IS true"]
  has_many :battle_buddy_requests_received, :conditions => ["battle_buddy_requests.accepted IS NOT true"], :class_name => 'BattleBuddyRequest', :foreign_key => 'battle_buddy_id'
  has_many :battle_buddy_requests_sent, :conditions => ["battle_buddy_requests.accepted IS NOT true"], :class_name => 'BattleBuddyRequest'
  has_many :crises, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  has_many :todos, :dependent => :destroy
  has_many :updates, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :managers, :conditions => ["users.role = 'manager'"], :class_name => 'User'
  has_many :executives, :conditions => ["users.role = 'executive'"], :class_name => 'User'
  has_many :editors, :conditions => ["users.role = 'editor'"], :class_name => 'User'
  has_many :readers, :conditions => ["users.role = 'reader'"], :class_name => 'User'

  accepts_nested_attributes_for :users

  validates_presence_of :name, :address, :city, :state, :zipcode, :organizational_status

  after_validation :geocode, :if => lambda{ |obj| (obj.changed.include?("address") || obj.changed.include?("city") || obj.changed.include?("state") || obj.changed.include?("zipcode"))  }

  after_create :send_sign_up_email, :send_admin_notification
  after_update :send_approval_email, :if => lambda{ |obj| (obj.changed.include?("active") && obj.active?)  }
  after_update :setup_initial_todo, :if => lambda{ |obj| (obj.changed.include?("active") && obj.active?)  }

  scope :approved, where(:active => true)
  scope :in_buddy_network, where(:battle_buddy_enabled => true)
  scope :to_approve, where(:active => false)
  scope :nearing_expiration, where('0=1')
  scope :in_crisis, includes(:crisis).where('crises.resolved_on IS NULL')
  
  delegate :is_complete?, :to => :assessment, :allow_nil => true, :prefix => true
  delegate :percentage_complete, :to => :assessment, :allow_nil => true, :prefix => true

  
  def self.with_user_activity_since(last=1.week.ago)
    approved.select('DISTINCT organizations.id').joins(:users).where('users.last_login_at > ?',last)
  end
  
  def self.activity_percentage(last=1.week.ago)
    ((Organization.with_user_activity_since(last).count.to_f / Organization.approved.count.to_f)*100).to_i rescue 0
  end
  
  def full_street_address
    [address, city, state, zipcode].compact.join(', ')
  end

  def gmaps4rails_address
    full_street_address
  end

  def todo_completion
    0
  end

  def deletable?
    # must deactivate an organization before deleting it
    !active? && users.all(&:disabled?)
  end
    
  def battle_buddy_list
    battle_buddies.collect(&:id).uniq
  end

  def battle_buddy_request_for(buddy)
    battle_buddy_requests.find_by_battle_buddy_id(buddy)
  end

  def last_activity
    users.order('last_login_at DESC').first.try(:last_activity) || 'Never'
  end

  def declared_crisis?
    crises.where(:resolved_on => nil).count == 1 ? true : false
  end

  def todo_percentage_complete
    # number_to_percentage(((completed_answers_count.to_f / answers_count.to_f)*100),:precision => 0)
    ((todos.completed.count.to_f / todos.count.to_f)*100).to_i rescue 0
  end
  
  def is_approved?
    active
  end

  private 
   
  def send_admin_notification
    logger.debug("Sending sign_up email for organization #{name}")
    User.admins.each do |admin|
      logger.debug("Trying to send to #{admin.email}")
      AdminMailer.new_organization(self,admin).deliver rescue logger.debug("send org notification to admin email failed")
    end
  end

  def send_sign_up_email
    logger.debug("Sending sign_up email for organization #{name}")
    OrganizationMailer.sign_up(self).deliver rescue logger.debug("send sign_up email failed")
  end

  def send_approval_email
    logger.debug("Sending approval email for organization #{name}")
    OrganizationMailer.approved(self).deliver rescue logger.debug("send approval email failed")
  end
  
  def setup_initial_todo
    logger.debug("setup_initial_todo: #{self.todos.count}")
    self.todos.create(:critical_function => 'people', :description => 'Add a second manager using the Settings menu to ensure access to the ArtsReady site', :priority => 'critical', :user => users.first, :due_on => Time.zone.now) if self.todos.count == 0
  end

end
