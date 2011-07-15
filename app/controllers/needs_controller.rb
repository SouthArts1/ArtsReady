class NeedsController < ApplicationController
  def create
    @need = current_org.crisis.needs.create(params[:need])
    if @need.save
      redirect_to crisis_path(current_org.crisis), :notice => "Need saved"
    else
      redirect_to crisis_path(current_org.crisis), :notice => "Problem saving your need"
    end
  end
end
