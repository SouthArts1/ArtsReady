class AdminMailer < ActionMailer::Base
  default :from => "no-reply@artsready.org"
  layout 'email'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin.review_public.subject
  #

  def new_organization(organization,admin)
    @organization = organization
    mail :to => admin.email, :subject => "There is a organization to approve.", :bcc => 'john.paul.ashenfelter@gmail.com'
  end

  def review_public(article,admin)
    @article = article
    mail :to => admin.email, :subject => "There is a new public article to review.", :bcc => 'john.paul.ashenfelter@gmail.com'
  end
  
  def review_comment(comment,admin)
    @comment = comment
    mail :to => admin.email, :subject => "There is a new comment to review.", :bcc => 'john.paul.ashenfelter@gmail.com'
  end
  
end
