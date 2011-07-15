class UpdatesController < ApplicationController
  
  def create
    @update = current_org.crisis.updates.create(params[:update])
    if @update.save
      redirect_to crisis_path(current_org.crisis), :notice => "Message sent"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem saving your update"
    end
  end
  
end
