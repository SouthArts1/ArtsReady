class BuddiesController < ApplicationController

  def get_help
    @buddies = current_org.nearbys(50).in_buddy_network
    @pending_buddies = []
  end

  def lend_a_hand
  end

  def index
  end

  def profile
    @resource = current_org.resources.new
  end

end