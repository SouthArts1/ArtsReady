class BillingMailer < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'
  helper :layout

  def subscription_renewal(organization)
    @organization = organization
    @user = @organization.users.first
    AdminMailer.subscription_renewal(organization).deliver
    mail :to => @user.email, :subject => "Your ArtsReady Subscription is about to Renew"
  end
  
  def setup_subscription_now(organization)
    @organization = organization
    @user = @organization.users.first
    mail :to => @user.email, :subject => "Your ArtsReady Account is about to Expire"
  end
end
