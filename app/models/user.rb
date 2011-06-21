class User < ActiveRecord::Base
  
  belongs_to :organization
  has_many :articles
  has_many :todos
  
  before_save :encrypt_password
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email

  validates_confirmation_of :password, :on => :create
  validates_uniqueness_of :email

  attr_accessor :password 
  
  accepts_nested_attributes_for :organization
  
  delegate :name, :to => :organization, :allow_nil => true, :prefix => true
  
  def self.authenticate(email, password)
    user = find_by_email(email)  
    if user && BCrypt::Password.new(user.encrypted_password) == password  
      user  
    else  
      nil  
    end  
  end
  
  def name
    "#{first_name} #{last_name}".strip
  end

  
  def encrypt_password  
    if password.present?  
      self.encrypted_password = BCrypt::Password.create(password)  
    end  
  end

end
