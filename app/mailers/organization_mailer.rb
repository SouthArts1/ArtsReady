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
    mail :to => user.email, :subject => "#{requesting_organization.name} would like to be your ArtsReady Battle Buddy"
  end
  
  def battle_buddy_dissolution(user, target_organization, requesting_organization)
    @requesting_organization = requesting_organization
    @target_organization = target_organization
    @other_organization = user.organization == @requesting_organization ? @target_organization : @requesting_organization
    mail :to => user.email, :subject => "#{requesting_organization.name} is no longer your Battle Buddy"
  end

end
