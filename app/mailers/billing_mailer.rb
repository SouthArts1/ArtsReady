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
    render_template_to_mail 'renewal reminder', organization
  end

  def credit_card_expiration(organization)
    render_template_to_mail 'credit card expiration', organization
  end

  private

  def render_template_to_mail(template_name, model)
    template = Template.find_usable(template_name)
    return unless template

    rendering = template.render(model)

    mail to: model.billing_emails,
      subject: rendering.subject,
      body: rendering.body,
      content_type: 'text/html'
  end
end
