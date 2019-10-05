class UpdatesController < ApplicationController

  def create
    @crisis = Crisis.find(params[:crisis_id])
    @update = @crisis.updates.build(update_params)
    @update.user = current_user
    @update.organization = current_org
    if @update.save
      redirect_to :back, :notice => "Message sent"
    else
      redirect_to :back, :notice => "Problem saving your update"
    end
  end

  private

  def update_params
    params.require(:update).permit(
      :message
    )
  end

end