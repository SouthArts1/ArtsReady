class BattleBuddyRequestsController < ApplicationController
  
  def create
    @bb_request = current_org.battle_buddy_requests.create(params[:battle_buddy_request]) 
    redirect_to get_help_path
  end
  
end
