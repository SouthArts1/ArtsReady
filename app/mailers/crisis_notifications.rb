class CrisisNotifications < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'
  
  def announcement(user,crisis)
    @crisis = crisis
    @user = user
    logger.debug("Sending crisis announcement for crisis #{crisis.id} to #{user.inspect}")
    begin
      mail :to => user.email, :subject => "ALERT! #{@crisis.organization.name} has declared a crisis through ArtsReady!"
    rescue
      logger.debug("Failed to send crisis announcement to #{user.inspect}")
    end
  end

  def resolved(user,crisis)
    @crisis = crisis
    @user = user
    begin
      mail :to => user.email, :subject => "Good news! #{@crisis.organization_name} has resolved their crisis through ArtsReady!"
    rescue
      logger.debug("Failed to send crisis resolution to #{user.inspect}")
    end
  end

  def latest_update(user,crisis,update)
    @crisis = crisis
    @update = update
    @user = user
    begin
      mail :to => user.email, :subject => "ALERT! #{@crisis.organization.name}'s crisis has been updated in ArtsReady!"
    rescue
      logger.debug("Failed to send crisis update to #{user.inspect}")
    end
  end

end
