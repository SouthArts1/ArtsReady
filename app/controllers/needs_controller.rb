class NeedsController < ApplicationController

  def create
    @need = current_org.crisis.needs.create(need_params)
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
    if @need.update_attributes(need_params)
      redirect_to crisis_path(current_org.crisis), :notice => "Need updated"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem updating your need"
    end
  end

  private
  
  def need_params
    params.require(:need).permit(
      :resource, :description, :provided, :provider
    )
  end
end
