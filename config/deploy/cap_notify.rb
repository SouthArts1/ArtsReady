require "action_mailer"

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :tls => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :authentication => "plain",
  :user_name => "test.tpoint",
  :password => "1qaz2wsx!"
}

class Notifier < ActionMailer::Base
  default :from => "test.tpoint@gmail.com"
  
  def deploy_notification(cap_vars)
    now = Time.now
    msg = "Deployed at #{now.strftime("%m/%d/%Y")} at #{now.strftime("%I:%M %p")}"
    
    mail(:to => cap_vars.notify_emails, 
         :subject => "Deployed #{cap_vars.application}") do |format|
      format.text { render :text => msg}
      format.html { render :text => "<p>" + msg + "<\p>"}
    end
  end
end