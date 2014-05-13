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

  def renewal_reminder(organization)
    template = Template.find_usable('renewal reminder')
    return unless template

    mail to: organization.billing_emails,
      subject: template.render_subject(organization),
      body: template.render(organization)
  end

  def renewal_receipt(payment)
    template = Template.find_usable('renewal receipt')
    return unless template

    mail to: payment.billing_emails,
      subject: template.render_subject(payment),
      body: template.render(payment)
  end
end
