class User < ActiveRecord::Base

  belongs_to :organization
  has_many :articles
  has_many :todos
  has_many :todo_notes
  before_save :encrypt_password

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email

  validates_confirmation_of :password, :on => :create
  validates_uniqueness_of :email

  attr_accessor :password

  delegate :name, :to => :organization, :allow_nil => true, :prefix => true

  before_save :set_default_role
  before_create :set_first_password, :if => "password.nil?"
  after_create :send_welcome_email

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && BCrypt::Password.new(user.encrypted_password) == password
      user.update_attribute(:last_login_at,Time.now)
      user
    else
      nil
    end
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def last_activity
    last_login_at.nil? ? 'Never' : last_login_at
  end

  def is_admin?
    true
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

end