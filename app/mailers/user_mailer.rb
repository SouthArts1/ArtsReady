class UserMailer < ActionMailer::Base
  default :from => "no-reply@artsready.org"
  layout 'email'

  def welcome(user)
    @greeting = "Hi"
    @user = user
    @link = root_url
    mail :to => user.email
  end
end
