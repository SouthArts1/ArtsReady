class OrganizationMailer < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'

  def sign_up(organization)
    @organization = organization
    @user = @organization.users.first
    mail :to => @user.email, :subject => "Your ArtsReady Profile is Pending Approval"
  end

  def approved(organization)
    @organization = organization
    @user = @organization.users.first
    mail :to => @user.email, :subject => "#{organization.name} is now part of ArtsReady!"
  end
  
  def battle_buddy_invitation(user,target_organization,requesting_organization)
    @user = user
    @target_organization = target_organization
    @requesting_organization = requesting_organization
    logger.debug("User => #{@user.inspect}")
    logger.debug("Target => #{@target_organization.inspect}")
    logger.debug("Requestor => #{@requesting_organization.inspect}")
    mail :to => user.email, :subject => "#{requesting_organization.name} would like to be your ArtsReady Battle Buddy"
  end
  
end
