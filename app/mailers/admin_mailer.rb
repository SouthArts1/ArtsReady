class AdminMailer < ActionMailer::Base
  ADMIN_RECIPIENTS = ['admin@artsready.org']

  default :from => "no-reply@artsready.org"
  layout 'email'
  helper :layout
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin.review_public.subject
  #

  def new_organization(organization,admin)
    @organization = organization
    mail :to => admin.email, :subject => "There is a organization to approve."
  end

  def review_public(article,admin)
    @article = article
    mail :to => admin.email, :subject => "There is a new public article to review."
  end
  
  def review_comment(comment,admin)
    @comment = comment
    mail :to => admin.email, :subject => "There is a new comment to review."
  end
  
  def subscription_renewal(organization)
    mail :to => ADMIN_RECIPIENTS, :subject => "An organization is coming up for renewal", :body => "#{organization.name} is coming up for renewal of #{money_from_cents organization.subscription.regular_amount_in_cents} in #{organization.subscription.days_left_until_rebill} days."
  end
  
  def organization_expired(organization)
    mail :to => ADMIN_RECIPIENTS, :subject => "An organization has expired", :body => "#{organization.name} has been marked expired in ArtsReady."
  end

  def renewing_organizations_notice
    @organizations = Organization.billing_this_month
    recipients = ADMIN_RECIPIENTS

    count = @organizations.count
    noun = 'ArtsReady organizations'.pluralize(count)
    subject = "#{count} #{noun} renewing soon"

    mail to: recipients, subject: subject
  end

  def credit_card_expiring_organizations_notice
    @organizations = Organization.credit_card_expiring_this_month
    recipients = ADMIN_RECIPIENTS

    count = @organizations.count
    noun = 'ArtsReady credit cards'.pluralize(count)
    subject = "#{count} #{noun} expiring soon"

    mail to: recipients, subject: subject
  end
end
