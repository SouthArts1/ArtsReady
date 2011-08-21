class CrisisNotifications < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'
  
  def announcement(user,crisis)
    @crisis = crisis
    mail :to => user.email, :subject => "#{@crisis.organization.name} declared a crisis!"
  end

  def resolved(user,crisis)
    @crisis = crisis
    mail :to => user.email, :subject => "#{@crisis.organization.name} resolved their crisis!"
  end

  def latest_update(user,crisis,update)
    @crisis = crisis
    @update = update
    mail :to => user.email, :subject => "#{@crisis.organization.name} has a crisis update."
  end

end