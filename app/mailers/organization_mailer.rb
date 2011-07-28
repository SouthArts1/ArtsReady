class OrganizationMailer < ActionMailer::Base
  default :from => "no-reply@artsready.com"
  layout 'email'

  def sign_up(organization)
    @organization = organization
    mail :to => organization.user.first.email, :subject => "Thank you for joining ArtsReady"
  end

  def approved(organization)
    @organization = organization
    mail :to => organization.user.first.email, :subject => "Your ArtsReady membership has been approved!"
  end
end
