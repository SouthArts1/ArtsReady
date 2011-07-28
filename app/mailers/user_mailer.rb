class UserMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  default :from => "no-reply@artsready.org"
  layout 'email'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @greeting = "Hi"
    @user = user
    @link = root_url
    mail :to => user.email
  end
end
