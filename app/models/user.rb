class User < ActiveRecord::Base

  belongs_to :organization, :counter_cache => true
  has_one :active_subscription, through: :organization
  has_many :articles
  has_many :messages
  has_many :todos
  has_many :todo_notes

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :password, :if => "encrypted_password.nil?"

  validates_confirmation_of :password
  validates_uniqueness_of :email
  validates_acceptance_of :accepted_terms, :accept => true, :on => :create
  
  validates_inclusion_of :role, :in => ArtsreadyDomain::ROLES

  attr_accessor :password

  delegate :name, :to => :organization, :allow_nil => true, :prefix => true
  delegate :assessment, :to => :organization

  scope :admins, where(:admin => true)
  scope :active, where(:disabled => false)
  scope :executives, where(:role => ['manager', 'executive'])
  scope :in_organizations, lambda { |*orgs_list|
    ids = orgs_list.map do | orgs |
      Array(orgs).map(&:id)
    end.flatten

    where(:organization_id => ids)
  }
  
  before_validation :set_first_password, :if => "password.nil? && encrypted_password.nil?"
  before_validation :set_default_role

  before_save :encrypt_password
  
  after_create :send_welcome_email, :if => lambda{ |obj| (obj.organization.active?) }
  
  after_save :add_to_mailchimp, :if => lambda{ |obj| (obj.changed.include?("email")) }

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && BCrypt::Password.new(user.encrypted_password) == password
      user.update_attribute(:last_login_at,Time.now)
      user
    else
      nil
    end
  end

  def self.admin_emails
    admins.pluck(:email)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def last_activity
    last_login_at
  end

  def is_admin?
    admin
  end
  
  def is_executive?
    ['manager','executive'].include?(role)
  end

  def encrypt_password
    if password.present?
      self.encrypted_password = BCrypt::Password.create(password)
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def set_default_role
    self.role = 'manager' unless organization && organization.active?
    self.role ||= 'reader'
  end
  
  def can_set_executive_permission_for_article?
    (role == 'executive' || role == 'manager')
  end
  
  def can_set_battlebuddy_permission_for_article?
    (role == 'executive' || role == 'manager' || role == 'editor')
  end

  def set_first_password
    logger.debug('no password so setting first password to random value')
    self.password = SecureRandom.urlsafe_base64
    encrypt_password
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver
  end

  def self.send_email_to_address?(addr)
    user = find_by_email(addr)

    !user || (!user.disabled? && user.organization.active?)
  end

  private 
  
  def mailchimp_merge_fields
    {
      :FNAME => first_name,
      :LNAME => last_name,
      :ORGNAME => organization.name,
      :ADDRESS1 => organization.address, 
      :ADDRESS2 => organization.address_additional,
      :CITY => organization.city,
      :STATE => organization.state,
      :ZIPCODE => organization.zipcode
    }  
  end
  
  def add_to_mailchimp
    begin
      gb = Gibbon.new(MAILCHIMP_API_KEY)
      user_info = mailchimp_merge_fields
      logger.debug("Sending #{user_info} to mailchimp list #{MAILCHIMP_LIST_ID}")
      response = gb.listSubscribe({:id => MAILCHIMP_LIST_ID, :email_address => email, :double_optin => false, :merge_vars => user_info})
    rescue Exception => e
      logger.debug(e.message) 
      logger.warn("Failed to register #{email} with mailchimp")
    end
    
  end

end
