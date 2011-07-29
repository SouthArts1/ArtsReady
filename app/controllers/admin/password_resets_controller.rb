class Admin::PasswordResetsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    user.send_password_reset if user
    redirect_to admin_organization_users_path(user.organization), :notice => "Email sent with password reset instructions."
  end

end
