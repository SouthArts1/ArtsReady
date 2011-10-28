class BuddiesController < ApplicationController

  def get_help
    params[:miles] ||= 50
    @buddies = current_org.nearbys(params[:miles].to_i).in_buddy_network
  end

  def lend_a_hand
    @messages = Message.limit(30).for_organization(current_org)
    @public_crises = Crisis.shared_with_the_community
    @network_crises = Crisis.shared_with_my_battle_buddy_network(current_org.battle_buddy_list)
    @private_crises = Crisis.shared_with_me(current_org)
  end

  def index
  end

  def show
    @buddy = Organization.find(params[:id])
  end
  
  def profile
    @resource = current_org.resources.new
    @resources = current_org.resources
  end

end