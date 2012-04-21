class BattleBuddyRequestsController < ApplicationController
  
  def create
    @bb_request = current_org.battle_buddy_requests.create(params[:battle_buddy_request]) 
    redirect_to get_help_path
  end
  
  def update
    @bb_request = BattleBuddyRequest.find(params[:id])
    return redirect_to(get_help_path, :notice => "There is a problem with that battle buddy request #{@bb_request.inspect}") unless @bb_request.battle_buddy == current_org

    if @bb_request.update_attributes({:accepted => true}) && current_org.battle_buddy_requests.create(:battle_buddy_id => @bb_request.organization_id, :accepted => true)
      redirect_to get_help_path, :notice => "Battle buddy added"
    else
      logger.debug(@bb_request.errors.inspect)
      redirect_to get_help_path, :notice => "Problem updating buddy"
    end

  end

  def destroy
    @bb_request = BattleBuddyRequest.find(params[:id])
    return redirect_to(:back, :notice => "There is a problem with that battle buddy request #{@bb_request.inspect}") unless @bb_request.can_be_deleted_by?(current_org)

    if @bb_request.update_attributes({:accepted => false}) && current_org.battle_buddy_requests.create(:battle_buddy_id => @bb_request.organization_id, :accepted => false)
      redirect_to :back, :notice => "Battle buddy removed."
    else
      logger.debug(@bb_request.errors.inspect)
      redirect_to :back, :notice => "Problem updating buddy"
    end

  end
  
end
