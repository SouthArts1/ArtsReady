class UserMailer < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'

  PASSWORD_RESET_SUBJECT = "Important Information about your ArtsReady Account"

  def welcome(user)
    @user = user
    mail :to => user.email, :subject => "Welcome to ArtsReady"
  end
  
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => PASSWORD_RESET_SUBJECT
  end
  
end
