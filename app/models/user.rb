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

  def set_default_role
    self.role ||= 'reader'
  end
end