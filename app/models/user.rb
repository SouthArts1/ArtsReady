class User < ActiveRecord::Base
  
  attr_accessor :password 
  
  before_save :encrypt_password
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email

  validates_confirmation_of :password, :on => :create
  validates_uniqueness_of :email
  
  def encrypt_password  
    if password.present?  
      self.encrypted_password = BCrypt::Password.create(password)  
    end  
  end

end
