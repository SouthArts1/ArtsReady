class BuddiesController < ApplicationController

  def get_help
    @buddies = current_org.nearbys(50).in_buddy_network
  end

  def lend_a_hand
    @buddies = current_org.nearbys(50).in_buddy_network
    @crises = current_org.nearbys(50).in_crisis
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