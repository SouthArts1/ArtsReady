class BattleBuddyRequestsController < ApplicationController
  
  def create
    @bb_request = current_org.battle_buddy_requests.create(battle_buddy_request_params)
    redirect_to get_help_path
  end
  
  def update
    @bb_request = BattleBuddyRequest.find(params[:id])
    return redirect_to(get_help_path, :notice => "There is a problem with that battle buddy request #{@bb_request.inspect}") unless @bb_request.battle_buddy == current_org

    if @bb_request.accept!
      redirect_to get_help_path, :notice => "Battle buddy added"
    else
      logger.debug(@bb_request.errors.inspect)
      redirect_to get_help_path, :notice => "Problem updating buddy"
    end

  end

  def destroy
    @bb_request = BattleBuddyRequest.find(params[:id])
    return redirect_to(:back, :notice => "There is a problem with that battle buddy request #{@bb_request.inspect}") unless @bb_request.can_be_deleted_by?(current_org)

    @bb_request.reject!
    redirect_to :back, :notice => "Battle buddy removed."
  end

  private

  def battle_buddy_request_params
    params.require(:battle_buddy_request).permit(
      :battle_buddy_id
    )
  end

end
