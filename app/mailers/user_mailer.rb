class UserMailer < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'

  def welcome(user)
    @user = user
    mail :to => user.email, :subject => "Welcome to ArtsReady"
  end
  
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Important Information about your ArtsReady Account"
  end
  
end
