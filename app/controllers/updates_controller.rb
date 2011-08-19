class UpdatesController < ApplicationController

  def create
    @crisis = Crisis.find(params[:crisis_id])
    @update = @crisis.updates.create(params[:update])
    @update.user = current_user
    @update.organization = current_org
    if @update.save
      redirect_to crisis_path(current_org.crisis), :notice => "Message sent"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem saving your update"
    end
  end

end