class Admin::HomeController < Admin::AdminController

  def dashboard
    @crises = Organization.in_crisis
    @expiring = []#Organization.nearing_expiration
  end

end