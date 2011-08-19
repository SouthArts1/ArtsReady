class BattleBuddyRequestsController < ApplicationController
  
  def create
    @bb_request = current_org.battle_buddy_requests.create(params[:battle_buddy_request]) 
    redirect_to get_help_path
  end
  
  def update
    @bb_request = BattleBuddyRequest.find(params[:id])

    if @bb_request.update_attributes({:accepted => true}) && current_org.battle_buddy_requests.create(:battle_buddy_id => @bb_request.organization_id, :accepted => true)
      redirect_to get_help_path, :notice => "Battle buddy added"
    else
      logger.debug(@bb_request.errors.inspect)
      redirect_to get_help_path, :notice => "Problem updating buddy"
    end

  end
  
end
