class Admin::HomeController < Admin::AdminController

  def dashboard
    @crises = Crisis.active
    @expiring = Organization.nearing_expiration
  end

end