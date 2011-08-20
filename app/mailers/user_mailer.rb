class UserMailer < ActionMailer::Base
  default :from => "no-reply@artsready.org"
  layout 'email'

  def welcome(user)
    @user = user
    mail :to => user.email, :subject => "Welcome to ArtsReady", :bcc => 'john.paul.ashenfelter@gmail.com'
  end
  
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "ArtsReady Password Reset", :bcc => 'john.paul.ashenfelter@gmail.com'
  end
  
end
