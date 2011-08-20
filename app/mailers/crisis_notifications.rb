class CrisisNotifications < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'
  
  def announce(crisis,user)
    @crisis = crisis
    mail :to => user.email, :subject => "#{@crisis.organization.name} declared a crisis!"
  end

  def resolved(crisis,user)
    @crisis = crisis
    mail :to => user.email, :subject => "#{@crisis.organization.name} resolved their crisis!"
  end

  def update(crisis,user,update)
    @crisis = crisis
    @update = update
    mail :to => user.email, :subject => "#{@crisis.organization.name} has a crisis update."
  end

end