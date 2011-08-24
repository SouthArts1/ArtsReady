class OrganizationMailer < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'

  def sign_up(organization)
    @organization = organization
    mail :to => organization.users.first.email, :subject => "Thank you for joining ArtsReady", :bcc => 'john.paul.ashenfelter@gmail.com'
  end

  def approved(organization)
    @organization = organization
    @user = @organization.users.first
    mail :to => @user.email, :subject => "#{organization.name} is now part of ArtsReady!", :bcc => 'john.paul.ashenfelter@gmail.com'
  end
end
