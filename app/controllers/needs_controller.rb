class NeedsController < ApplicationController

  def create
    @need = current_org.crisis.needs.create(params[:need])
    if @need.save
      redirect_to crisis_path(current_org.crisis), :notice => "Need saved"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem saving your need"
    end
  end

  def edit
    @need = current_org.crisis.needs.find(params[:id])
  end
  
  def update
    @need = current_org.crisis.needs.find(params[:id])
    if @need.update_attributes(params[:need])
      redirect_to crisis_path(current_org.crisis), :notice => "Need updated"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem updating your need"
    end
  end


end
