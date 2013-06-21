class BuddiesController < ApplicationController

  def get_help
    params[:miles] ||= 50
    @buddies = current_org.nearbys(params[:miles].to_i).in_buddy_network.approved
  end

  def lend_a_hand
    redirect_to(buddies_profile_path, :notice => 'Join the Battle Buddy Network') unless current_org.battle_buddy_enabled?
    @messages = Message.for_organization(current_org)
    crises = Crisis.of_active_org
    @public_crises = crises.shared_with_the_community
    @network_crises = crises.shared_with_my_battle_buddy_network(current_org.battle_buddy_list)
    @private_crises = crises.shared_with_me(current_org)
  end

  def index
    # doing this now, so it isn't forgotten if we ever go back to the BBN index
    @buddies = current_org.battle_buddies.approved
  end

  def show
    redirect_to(buddies_profile_path, :notice => 'Join the Battle Buddy Network') unless current_org.battle_buddy_enabled?
    @buddy = Organization.find(params[:id])
  end
  
  def profile
    @resource = current_org.resources.new
    @resources = current_org.resources.all
  end

end
