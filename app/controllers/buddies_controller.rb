class BuddiesController < ApplicationController

  def get_help
    params[:miles] ||= 50
    @buddies = current_org.nearbys(params[:miles].to_i).in_buddy_network
  end

  def lend_a_hand
    @crises = Crisis.active
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