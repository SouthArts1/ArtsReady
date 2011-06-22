class BuddiesController < ApplicationController
  def get_help
    @buddies = current_org.nearbys(50)
  end

  def lend_a_hand
  end

  def index
  end

  def profile
  end
end
