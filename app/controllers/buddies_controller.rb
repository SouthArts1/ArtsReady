class BuddiesController < ApplicationController

  def get_help
    params[:miles] ||= 50
    @buddies = current_org.nearbys(params[:miles].to_i).in_buddy_network
  end

  def lend_a_hand
    @public_crises = Crisis.active.visible_to_all
    # @network_crises = Crisis.in_my_network(current_org)
    # @private_crises = Crisis.privately_shared(current_org)
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